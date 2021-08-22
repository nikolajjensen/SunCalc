//
//  MoonTimes.swift
//  MoonTimes
//
//  Copyright © 2021 Nikolaj Banke Jensen
//
//  NOTICE: This file has been modified under compliance with the Apache 2.0 License
//  from the original work of Richard "Shred" Körber. This file has been modified
//  by translation from Java to Swift, including appropriate refactoring and adaptation.
//
//  The original work can be found here: https://github.com/shred/commons-suncalc
//
//  --------------------------------------------------------------------------------
//
//  Copyright (C) 2017 Richard "Shred" Körber
//    http://commons.shredzone.org
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//

import Foundation

/// Calculates the rise and set times of the Moon.
public struct MoonTimes: CustomStringConvertible {
    
    /// Moonrise time.
    ///
    /// 'nil' if the Moon does not rise that day.
    public let rise: DateTime?
    
    /// Moonset time.
    ///
    /// 'nil' if the Moon dos not set that day.
    public let set: DateTime?
    
    /// True if the Moon never rises/sets, but is always above the horizon.
    public let alwaysUp: Bool
    
    /// True if the Moon never rises/sets, but is always below the horizon.
    public let alwaysDown: Bool
    
    /// Description of MoonTimes structure.
    public var description: String {
        return "MoonTimes[rise=\(rise as Optional), set=\(set as Optional), alwaysUp=\(alwaysUp), alwaysDown=\(alwaysDown)]"
    }
    
    init(rise: DateTime?, set: DateTime?, alwaysUp: Bool, alwaysDown: Bool) {
        self.rise = rise
        self.set = set
        self.alwaysUp = alwaysUp
        self.alwaysDown = alwaysDown
    }
    
    /// Starts the computation of MoonTimes.
    /// - Returns: A MoonTimesBuilder which we can set parameters for by calling its functions.
    public static func compute() -> MoonTimesBuilder {
        return MoonTimesBuilder()
    }
    
    /// Builder for MoonTimes.
    ///
    /// Performs the computations based on the parameters, and creates a MoonTimes structure that holds the result.
    public class MoonTimesBuilder: BaseBuilder<MoonTimesBuilder>, Builder, MoonTimesParameters {
        public typealias P = MoonTimesBuilder
        public typealias T = MoonTimes
        
        private var limit: Double = TimeInterval.ofDays(365)
        private var refraction: Double = ExtendedMath.apparentRefraction(0.0)
        
        /// Limits the calculation window to the given TimeInterval.
        /// - Parameter duration: TimeInterval marking the calculation window. Must be positive.
        /// - Throws: If the limit could not be set.
        /// - Returns: The Builder.
        public func limit( _ duration: TimeInterval?) throws -> MoonTimesBuilder {
            guard let duration = duration, duration >= 0 else {
                throw SunCalcError.illegalArgumentError("Duration is nil or negative")
            }
            limit = duration
            return self
        }
        
        /// Computes the MoonTimes structure based on parameters set.
        /// - Throws: If the MoonTimes could not be calculated.
        /// - Returns: MoonTimes structure.
        public func execute() throws -> MoonTimes {
            let jd = julianDate
            
            var rise: Double?
            var set: Double?
            var alwaysUp: Bool = false
            var alwaysDown: Bool = false
            var ye: Double
            
            var hour: Double = 0
            let limitHours: Double = limit / (60 * 60)
            let maxHours: Double = ceil(limitHours)
            
            var yMinus = try correctedMoonHeight(jd.atHour(hour - 1.0))
            var y0 = try correctedMoonHeight(jd.atHour(hour))
            var yPlus = try correctedMoonHeight(jd.atHour(hour + 1.0))
            
            (y0 > 0.0) ? (alwaysUp = true) : (alwaysDown = true)
            
            while hour <= maxHours {
                let qi = QuadraticInterpolation(yMinus: yMinus, y0: y0, yPlus: yPlus)
                ye = qi.ye
                
                if qi.numberOfRoots == 1 {
                    let rt = qi.root1 + hour
                    if yMinus < 0.0 {
                        if (rise == nil && rt >= 0.0 && rt < limitHours) {
                            rise = rt
                            alwaysDown = false
                        }
                    } else {
                        if (set == nil && rt >= 0.0 && rt < limitHours) {
                            set = rt
                            alwaysUp = false
                        }
                    }
                } else if qi.numberOfRoots == 2 {
                    if (rise == nil) {
                        let rt = hour + (ye < 0.0 ? qi.root2 : qi.root1)
                        if (rt >= 0.0 && rt < limitHours) {
                            rise = rt;
                            alwaysDown = false;
                        }
                    }
                    if (set == nil) {
                        let rt = hour + (ye < 0.0 ? qi.root1 : qi.root2)
                        if (rt >= 0.0 && rt < limitHours) {
                            set = rt
                            alwaysUp = false
                        }
                    }
                }
                
                if rise != nil && set != nil {
                    break
                }
                
                hour += 1
                yMinus = y0
                y0 = yPlus
                yPlus = try correctedMoonHeight(jd.atHour(hour + 1.0))
            }
            
            return MoonTimes(
                rise: rise != nil ? jd.atHour(rise!).dateTime : nil,
                set: set != nil ? jd.atHour(set!).dateTime : nil,
                alwaysUp: alwaysUp,
                alwaysDown: alwaysDown)
        }
        
        /// Computes the Moon height at the given date and position.
        /// - Parameter jd: JulianDate to use.
        /// - Throws: If the corrected Moon height could not be calculated.
        /// - Returns: Height, in radians.
        private func correctedMoonHeight(_ jd: JulianDate) throws -> Double {
            var pos = try Moon.positionHorizontal(date: jd, lat: latitudeRad, lng: longitudeRad)
            let hc = ExtendedMath.parallax(height: height, distance: pos.getR()) - refraction - Moon.angularRadius(pos.getR())
            return pos.getTheta() - hc
        }
    }
}

/// Additional parameters that a Builder which is capable of calculating MoonTimes needs to implement.
protocol MoonTimesParameters {
    associatedtype P
    
    /// Limits the calculation window to the given TimeInterval.
    /// - Parameter duration: TimeInterval marking the calculation window. Must be positive.
    /// - Throws: If the limit could not be set.
    /// - Returns: The Builder.
    func limit(_ duration: TimeInterval?) throws -> P
}

extension MoonTimesParameters {
    /// Limits the calculation window to the next 24 hours.
    /// - Throws: If the limit could not be set.
    /// - Returns: The Builder.
    func oneDay() throws -> P {
        return try limit(TimeInterval.ofDays(1))
    }
    
    /// Computes until all rise and set times are found (365 days).
    ///
    /// This is the default.
    /// - Throws: If the limit could not be set.
    /// - Returns: The Builder.
    func fullCycle() throws -> P {
        return try limit(TimeInterval.ofDays(365))
    }
}
