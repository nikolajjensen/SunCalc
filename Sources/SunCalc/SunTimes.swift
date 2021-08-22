//
//  SunTimes.swift
//  SunTimes
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

/// Calculates the rise and set times of the Sun.
public struct SunTimes: CustomStringConvertible {
    
    /// Sunrise time.
    ///
    /// Will have value 'nil' if the Sun does not rise that day.
    public let rise: DateTime?
    
    /// Sunset time.
    ///
    /// Will have value 'nil' if the Sun does not set that day.
    public let set: DateTime?
    
    /// The time when the Sun reaches its highest point.
    ///
    /// Use 'isAlwaysDown' to find out if the highest point is still below the twilight angle.
    public let noon: DateTime?
    
    /// The time when the Sun reaches its lowest point.
    ///
    /// Use 'isAlwaysUp' to find out if the lowest point is still above the twilight angle.
    public let nadir: DateTime?
    
    /// True if the sun never rises/sets, but is always above the twilight angle.
    public let alwaysUp: Bool
    
    /// True if the sun never rises/sets, but is always below the twilight angle.
    public let alwaysDown: Bool
    
    /// Description of SunTimes structure.
    public var description: String {
        return "SunTimes[rise=\(rise as Optional), set=\(set as Optional), noon=\(noon as Optional), nadir=\(nadir as Optional), alwaysUp=\(alwaysUp as Optional), alwaysDown=\(alwaysDown as Optional)]"
    }
    
    init(rise: DateTime?, set: DateTime?, noon: DateTime?, nadir: DateTime?, alwaysUp: Bool, alwaysDown: Bool) {
        self.rise = rise
        self.set = set
        self.noon = noon
        self.nadir = nadir
        self.alwaysUp = alwaysUp
        self.alwaysDown = alwaysDown
    }

    /// Starts the computation of SunTimes.
    /// - Returns: A SunTimesBuilder which we can set parameters for by calling its functions.
    public static func compute() -> SunTimesBuilder {
        return SunTimesBuilder()
    }
    
    /// Builder for SunTimes.
    ///
    /// Performs the computations based on the parameters, and creates a SunTimes structure that holds the result.
    public class SunTimesBuilder: BaseBuilder<SunTimesBuilder>, Builder, SunTimesParameters {
        public typealias P = SunTimesBuilder
        public typealias T = SunTimes
        
        private var angle: Double = Twilight.visual.angleRad
        private var position: Double? = Twilight.visual.position
        private var limit: Double = TimeInterval.ofDays(365)
        
        /// Sets the Twilight mode.
        /// - Parameter twilight: Twilight mode to be used.
        /// - Returns: The Builder.
        public func twilight(_ twilight: Twilight) -> SunTimesBuilder {
            self.angle = twilight.angleRad
            self.position = twilight.position
            return self
        }
        
        /// Sets the desired elevation angle of the sun.
        ///
        /// The sunrise and sunset times are referring to the moment when the center of
        /// the sun passes this angle.
        /// - Parameter angle: Geocentric elevation angle, in degrees.
        /// - Returns: The Builder.
        public func twilight(_ angle: Double) -> SunTimesBuilder {
            self.angle = ExtendedMath.toRadians(angle)
            self.position = nil
            return self
        }
        
        /// Limits the calculation window to the given TimeInterval.
        /// - Parameter duration: TimeInterval marking the calculation window. Must be positive.
        /// - Throws: If the limit could not be set.
        /// - Returns: The Builder.
        public func limit(_ duration: TimeInterval?) throws -> SunTimesBuilder {
            guard let duration = duration, duration >= 0 else {
                throw SunCalcError.illegalArgumentError("Duration is nil or negative")
            }
            limit = duration
            return self
        }
        
        /// Computes the SunTimes structure based on parameters set.
        /// - Throws: If the SunTimes could not be calculated.
        /// - Returns: SunTimes structure.
        public func execute() throws -> SunTimes {
            let jd = julianDate
            
            var rise: Double?
            var set: Double?
            var noon: Double?
            var nadir: Double?
            var alwaysUp: Bool = false
            var alwaysDown: Bool = false
            var ye: Double
            
            var hour: Double = 0
            let limitHours: Double = limit / (60 * 60)
            let maxHours: Double = ceil(limitHours)
            
            var yMinus = try correctedSunHeight(jd.atHour(hour - 1.0))
            var y0 = try correctedSunHeight(jd.atHour(hour))
            var yPlus = try correctedSunHeight(jd.atHour(hour + 1.0))
            
            
            (y0 > 0.0) ? (alwaysUp = true) : (alwaysDown = true)
            
            while hour <= maxHours {
                let qi = QuadraticInterpolation(yMinus: yMinus, y0: y0, yPlus: yPlus)
                ye = qi.ye
                
                if qi.numberOfRoots == 1 {
                    let rt = qi.root1 + hour
                    if yMinus < 0 {
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
                    if rise == nil {
                        let rt = hour + (ye < 0.0 ? qi.root2 : qi.root1)
                        if rt >= 0.0 && rt < limitHours {
                            rise = rt
                            alwaysDown = false
                        }
                    }
                    
                    if set == nil {
                        let rt = hour + (ye < 0.0 ? qi.root1 : qi.root2)
                        if rt >= 0.0 && rt < limitHours {
                            set = rt
                            alwaysUp = false
                        }
                    }
                }
                
                let xeAbs = abs(qi.xe)
                
                if xeAbs <= 1.0 {
                    let xeHour = qi.xe + hour
                    if xeHour >= 0.0 {
                        if qi.isMaximum {
                            if noon == nil {
                                noon = xeHour
                            }
                        } else {
                            if nadir == nil {
                                nadir = xeHour
                            }
                        }
                    }
                }
                
                if rise != nil && set != nil && noon != nil && nadir != nil {
                    break
                }
                
                hour += 1
                yMinus = y0
                y0 = yPlus
                yPlus = try correctedSunHeight(jd.atHour(hour + 1.0))
            }
            
            if let noonUnwrapped = noon {
                noon = try ExtendedMath.readjustMax(time: noonUnwrapped, frame: 2.0, depth: 14, f: {t in try correctedSunHeight(jd.atHour(t))})
                if (noonUnwrapped < 0.0 || noonUnwrapped >= limitHours) {
                    noon = nil
                }
            }
            
            if let nadirUnwrapped = nadir {
                nadir = try ExtendedMath.readjustMin(time: nadirUnwrapped, frame: 2.0, depth: 14, f: {t in try correctedSunHeight(jd.atHour(t))})
                if (nadirUnwrapped < 0.0 || nadirUnwrapped >= limitHours) {
                    nadir = nil
                }
            }

            return SunTimes(
                rise: rise != nil ? jd.atHour(rise!).dateTime : nil,
                set: set != nil ? jd.atHour(set!).dateTime : nil,
                noon: noon != nil ? jd.atHour(noon!).dateTime : nil,
                nadir: nadir != nil ? jd.atHour(nadir!).dateTime : nil,
                alwaysUp: alwaysUp,
                alwaysDown: alwaysDown)
        }
        
        /// Computes the Sun height at the given date and position.
        /// - Parameter jd: JulianDate to use.
        /// - Throws: If the corrected Moon height could not be calculated.
        /// - Returns: Height, in radians.
        private func correctedSunHeight(_ jd: JulianDate) throws -> Double {
            var pos = try Sun.positionHorizontal(date: jd, lat: latitudeRad, lng: longitudeRad)
            
            var hc: Double = angle
            
            guard let position = position else {
                return pos.getTheta() - hc
            }

            hc -= ExtendedMath.apparentRefraction(hc)
            hc += ExtendedMath.parallax(height: height, distance: pos.getR())
            hc -= position * Sun.angularRadius(pos.getR())
            
            let v = pos.getTheta() - hc
            return v
        }
    }
}

/// Additional parameters that a Builder which is capable of calculating SunTimes needs to implement.
protocol SunTimesParameters {
    associatedtype P
    
    /// Sets the Twilight mode.
    /// - Parameter twilight: Twilight mode to be used.
    /// - Returns: The Builder.
    func twilight(_ twilight: Twilight) -> P
    
    /// Sets the desired elevation angle of the sun.
    ///
    /// The sunrise and sunset times are referring to the moment when the center of
    /// the sun passes this angle.
    /// - Parameter angle: Geocentric elevation angle, in degrees.
    /// - Returns: The Builder.
    func twilight(_ angle: Double) -> P
    
    /// Limits the calculation window to the given TimeInterval.
    /// - Parameter duration: TimeInterval marking the calculation window. Must be positive.
    /// - Throws: If the limit could not be set.
    /// - Returns: The Builder.
    func limit(_ duration: TimeInterval?) throws -> P
}

extension SunTimesParameters {
    /// Limits the calculation window to the next 24 hours.
    /// - Throws: If the limit could not be set.
    /// - Returns: The Builder.
    func oneDay() throws -> P {
        return try limit(TimeInterval.ofDays(1))
    }
    
    /// Computes until all rise, set, noon, and nadir times are found (365 days).
    /// 
    /// This is the default.
    /// - Throws: If the limit could not be set.
    /// - Returns: The Builder.
    func fullCycle() throws -> P {
        return try limit(TimeInterval.ofDays(365))
    }
}
