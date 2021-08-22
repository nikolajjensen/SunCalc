//
//  Sun.swift
//  Sun
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

/// Calculations and constants relating to the Sun.
///
/// See:
///
/// Astronomy on the Personal Computer, 4th edition
/// (Oliver Montenbruck, Thomas Pfleger) -
/// ISBN 978-3-540-67221-0
struct Sun {
    private static let sunDistance: Double = 149598000.0
    private static let sunMeanRadius: Double = 695700.0
    
    /// Calculates the equatorial position of the Sun.
    /// - Parameter date: JulianDate to be used.
    /// - Throws: If the equatorial position could not be calculated for this date.
    /// - Returns: A Vector containing the Sun position.
    static func positionEquatorial(_ date: JulianDate) throws -> Vector {
        let T = date.julianCentury
        let M = ExtendedMath.pi2 * ExtendedMath.frac(0.993133 + 99.997361 * T)
        let L = ExtendedMath.pi2 * ExtendedMath.frac(0.7859453 + M / ExtendedMath.pi2 + (6893.0 * sin(M) + 72.0 * sin(2.0 * M) + 6191.2 * T) / 1296.0e3)
        let d = sunDistance * (1 - 0.016718 * cos(try date.getTrueAnomaly()))
        
        return Vector.ofPolar(L, 0.0, d)
    }
    
    /// Calculates the geocentric position of the Sun.
    /// - Parameter date: JulianDate to be used.
    /// - Throws: If the position could not be calculated for this date.
    /// - Returns: A Vector containing the Sun position.
    static func position(_ date: JulianDate) throws -> Vector {
        let rotateMatrix = try ExtendedMath.equatorialToEcliptical(date).transpose()
        let r = try rotateMatrix.multiply(positionEquatorial(date))
        return r
    }
    
    /// Calculates the horizontal position of the Sun.
    /// - Parameters:
    ///   - date: JulianDate to be used.
    ///   - lat: Latitude, in radians.
    ///   - lng: Longitude, in radians.
    /// - Throws: If the horizontal position could not be calculated for this date.
    /// - Returns: A Vector containing the Sun position.
    static func positionHorizontal(date: JulianDate, lat: Double, lng: Double) throws -> Vector {
        var mc = try position(date)
        let h = date.getGreenwichMeanSiderealTime() + lng - mc.getPhi()
        return try ExtendedMath.equatorialToHorizontal(tau: h, dec: mc.getTheta(), dist: mc.getR(), lat: lat)
    }
    
    /// Returns the angular radius of the Sun.
    ///
    /// See this Wikipedia entry: https://en.wikipedia.org/wiki/Angular_diameter
    /// - Parameter distance: Distance of the Sun.
    /// - Returns: Angular radius of the Sun, in radians.
    static func angularRadius(_ distance: Double) -> Double {
        return asin(sunMeanRadius / distance)
    }
}
