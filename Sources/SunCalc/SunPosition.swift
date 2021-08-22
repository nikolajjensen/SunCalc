//
//  SunPosition.swift
//  SunPosition
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

/// Calculates the position of the Sun.
public struct SunPosition: CustomStringConvertible {
    
    /// Sun azimuth, in degrees, north-based.
    ///
    /// This is the direction along the horizon, measured from north to east. For example,
    /// 0.0 means north, 135.0 means southeast, 270 means west.
    public let azimuth: Double
    
    /// The visible Sun altitude above the horizon, in degrees.
    ///
    /// 0.0 means the Sun's center is at the horizon, 90.0 means it is at the zenith.
    /// Atmospheric refration is taken into account.
    public let altitude: Double
    
    /// The true sun altitude above the horizon, in degrees.
    ///
    /// 0.0 means the Sun's center is at the horizon, 90.0 means it is at the zenith.
    public let trueAltitude: Double
    
    /// Sun's distance, in kilometers.
    public let distance: Double
    
    /// Description of SunPosition structure.
    public var description: String {
        return "SunPosition[azimuth=\(azimuth)°, altitude=\(altitude)°, true altitude=\(trueAltitude)°, distance=\(distance)km]"
    }
    
    init(azimuth: Double, altitude: Double, trueAltitude: Double, distance: Double) {
        self.azimuth = (ExtendedMath.toDegrees(azimuth) + 180).truncatingRemainder(dividingBy: 360)
        self.altitude = ExtendedMath.toDegrees(altitude)
        self.trueAltitude = ExtendedMath.toDegrees(trueAltitude)
        self.distance = distance
    }
    
    /// Starts the computation of Sun position.
    /// - Returns: A SunPositionBuilder which we can set parameters for by calling its functions.
    public static func compute() -> SunPositionBuilder {
        return SunPositionBuilder()
    }
    
    /// Builder for SunPosition.
    ///
    /// Performs the computations based on the parameters, and creates a SunPosition structure that holds the result.
    public class SunPositionBuilder: BaseBuilder<SunPositionBuilder>, Builder {
        public typealias T = SunPosition
        
        /// Computes the SunPosition structure based on parameters set.
        /// - Throws: If the SunPosition could not be calculated.
        /// - Returns: SunPosition structure.
        public func execute() throws -> SunPosition {
            let t = julianDate
            
            let lw = ExtendedMath.toRadians(-longitude)
            let phi = ExtendedMath.toRadians(latitude)
            var c = try Sun.position(t)
            let h = t.getGreenwichMeanSiderealTime() - lw - c.getPhi()
            var horizontal = try ExtendedMath.equatorialToHorizontal(tau: h, dec: c.getTheta(), dist: c.getR(), lat: phi)
            let hRef = ExtendedMath.refraction(horizontal.getTheta())
            
            return SunPosition(
                azimuth: horizontal.getPhi(),
                altitude: horizontal.getTheta() + hRef,
                trueAltitude: horizontal.getTheta(),
                distance: horizontal.getR())
        }
    }
}
