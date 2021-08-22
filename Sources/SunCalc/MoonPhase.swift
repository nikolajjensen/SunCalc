//
//  MoonPhase.swift
//  MoonPhase
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

/// Calculates the date and time when the Moon reaches the desired phase.
///
/// Note: Due to simplified formulas used in 'suncalc', the returned time can have an error of several minutes.
public struct MoonPhase: CustomStringConvertible {
    
    /// Date and time of the desired Moon phase.
    public let dateTime: DateTime
    
    /// Geocentric distance of the Moon at the given phase, in kilometers.
    public let distance: Double
    
    /// Checks if the Moon is in a Supermoon position.
    ///
    /// Note that there is no official definition of 'Supermoon'. We will assume a Supermoon if the center
    /// of the Moon is closer than 360,000 km to the center of the Earth. Usually only full Moons or New Moons
    /// are candidates for Supermoons.
    public var isSuperMoon: Bool {
        return distance < 360000.0
    }
    
    /// Checks if the Moon is in a Micromoon position.
    ///
    /// Note that there is no official definition of 'Micromoon'. We will assume a Micromoon if the center
    /// of the Moon is farther than 405,000 km to the center of the Earth. Usually only full Moons or New Moons
    /// are candidates for Micromoons.
    public var isMicroMoon: Bool {
        return distance > 405000.0
    }
    
    /// Description of the MoonPhase structure.
    public var description: String {
        return "MoonPhase[dateTime=\(dateTime), distance=\(distance)km]"
    }
    
    init(dateTime: DateTime, distance: Double) {
        self.dateTime = dateTime
        self.distance = distance
    }
    
    /// Starts the computation of Moon phase.
    /// - Returns: A MoonPhaseBuilder which we can set parameters for by calling its functions.
    public static func compute() -> MoonPhaseBuilder {
        return MoonPhaseBuilder()
    }
    
    /// Builder for MoonPhase.
    ///
    /// Performs the computations based on the parameters, and creates a MoonPhase structure that holds the result.
    public class MoonPhaseBuilder: BaseBuilder<MoonPhaseBuilder>, Builder, MoonPhaseParameters {
        public typealias P = MoonPhaseBuilder
        public typealias T = MoonPhase
        
        private let sunLightTimeTau = 8.32 / (1440.0 * 36525.0)
        private var phase = Phase.newMoon.angleRad
        
        /// Sets the desired Phase.
        ///
        /// Default is 'Phase.newMoon'.
        /// - Parameter phase: The Phase to set.
        /// - Returns: The Builder.
        public func phase(_ phase: Phase) -> MoonPhaseBuilder {
            self.phase = phase.angleRad
            return self
        }
        
        /// Sets a free Phase to be used.
        /// - Parameter phase: Desired phase, in degrees. 0 = new moon, 90 = first quarter, 180 = full moon, 270 = third quarter
        /// - Returns: The Builder.
        public func phase(_ phase: Double) -> MoonPhaseBuilder {
            self.phase = ExtendedMath.toRadians(phase)
            return self
        }
        
        /// Computes the MoonPhase structure based on parameters set.
        /// - Throws: If the MoonPhase could not be calculated.
        /// - Returns: MoonPhase structure.
        public func execute() throws -> MoonPhase {
            let jd = julianDate
            
            let dT = 7.0 / 36525.0
            let accuracy = (0.5 / 1440.0) / 36525.0
            
            var t0 = jd.julianCentury
            var t1 = t0 + dT
            
            var d0 = try moonphase(jd, t0)
            var d1 = try moonphase(jd, t1)
            
            while (d0 * d1 > 0.0 || d1 < d0) {
                t0 = t1
                d0 = d1
                t1 += dT
                d1 = try moonphase(jd, t1)
            }
            
            let tPhase = try Pegasus.calculate(lower: t0, upper: t1, accuracy: accuracy, f: {t in try moonphase(jd, t)})
            let tjd = jd.atJulianCentury(tPhase)
            var moonPosEquatorial = Moon.positionEquatorial(tjd)
            
            return MoonPhase(dateTime: tjd.dateTime, distance: moonPosEquatorial.getR())
        }
        
        /// Calculates the position of the Moon at the given Phase.
        /// - Parameters:
        ///   - jd: Base JulianDate.
        ///   - t: Ephemeris time.
        /// - Throws: If the position could not be calculated.
        /// - Returns: Difference angle of the Sun's and Moon's position.
        private func moonphase(_ jd: JulianDate, _ t: Double) throws -> Double {
            var sun = try Sun.positionEquatorial(jd.atJulianCentury(t - sunLightTimeTau))
            var moon = Moon.positionEquatorial(jd.atJulianCentury(t))
            
            var diff = moon.getPhi() - sun.getPhi() - phase
            while diff < 0.0 {
                diff += ExtendedMath.pi2
            }
            
            return ((diff + Double.pi).truncatingRemainder(dividingBy: ExtendedMath.pi2) - Double.pi)
        }
    }
}

/// Additional parameters that a Builder which is capable of calculating MoonPhase needs to implement.
protocol MoonPhaseParameters {
    associatedtype P
    
    /// Sets the desired Phase.
    ///
    /// Default is 'Phase.newMoon'.
    /// - Parameter phase: The Phase to set.
    /// - Returns: The Builder.
    func phase(_ phase: Phase) -> P
    
    /// Sets a free Phase to be used.
    /// - Parameter phase: Desired phase, in degrees. 0 = new moon, 90 = first quarter, 180 = full moon, 270 = third quarter
    /// - Returns: The Builder.
    func phase(_ phase: Double) -> P
}
