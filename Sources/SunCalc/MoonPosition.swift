//
//  MoonPosition.swift
//  MoonPosition
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

/// Calculates the position of the Moon.
public struct MoonPosition: CustomStringConvertible {
    /// Moon azimuth, in degrees, north-based.
    ///
    /// This is the direction along the horizon, measured from north to east. For example,
    /// 0.0 means north, 135.0 means southeast, 270 means west.
    public let azimuth: Double
    
    /// The visible Moon altitude above the horizon, in degrees.
    ///
    /// 0.0 means the Moon's center is at the horizon, 90.0 means it is at the zenith.
    /// Atmospheric refration is taken into account.
    public let altitude: Double
    
    /// Moon's distance, in kilometers.
    public let distance: Double
    
    /// Parallactic angle of the Moon, in degrees.
    public let parallacticAngle: Double
    
    /// Description of the MoonPosition structure.
    public var description: String {
        return "MoonPosition[azimuth=\(azimuth)°, altitude=\(altitude)°, distance=\(distance)km, parallactic angle=\(parallacticAngle)°]"
    }
    
    init(azimuth: Double, altitude: Double, distance: Double, parallacticAngle: Double) {
        self.azimuth = (ExtendedMath.toDegrees(azimuth) + 180).truncatingRemainder(dividingBy: 360)
        self.altitude = ExtendedMath.toDegrees(altitude)
        self.distance = distance
        self.parallacticAngle = ExtendedMath.toDegrees(parallacticAngle)
    }
    
    /// Starts the computation of Moon position.
    /// - Returns: A MoonPositionBuilder which we can set parameters for by calling its functions.
    public static func compute() -> MoonPositionBuilder {
        return MoonPositionBuilder()
    }
    
    /// Builder for MoonPosition.
    ///
    /// Performs the computations based on the parameters, and creates a MoonPosition structure that holds the result.
    public class MoonPositionBuilder: BaseBuilder<MoonPositionBuilder>, Builder {
        public typealias T = MoonPosition
        
        /// Computes the MoonPosition structure based on parameters set.
        /// - Throws: If the MoonPosition could not be calculated.
        /// - Returns: MoonPosition structure.
        public func execute() throws -> MoonPosition {
            let t = julianDate
            
            let phi: Double = latitudeRad
            let lambda: Double = longitudeRad
            
            var mc = try Moon.position(t)
            let h: Double = t.getGreenwichMeanSiderealTime() + lambda - mc.getPhi()
            
            var horizontal = try ExtendedMath.equatorialToHorizontal(tau: h, dec: mc.getTheta(), dist: mc.getR(), lat: phi)
            
            let hRef = ExtendedMath.refraction(horizontal.getTheta())
            
            let pa = atan2(sin(h), tan(phi) * cos(mc.getTheta())) - sin(mc.getTheta()) * cos(h)
            
            return MoonPosition(
                azimuth: horizontal.getPhi(),
                altitude: horizontal.getTheta() + hRef,
                distance: mc.getR(),
                parallacticAngle: pa)
        }
    }
}
