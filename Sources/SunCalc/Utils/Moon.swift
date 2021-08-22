//
//  Moon.swift
//  Moon
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
struct Moon {
    static let moonMeanRadius = 1737.1
    
    /// Calculates the equatorial position of the Moon.
    /// - Parameter date: JulianDate to be used.
    /// - Throws: If the equatorial position could not be calculated for this date.
    /// - Returns: A Vector containing the Moon position.
    static func positionEquatorial(_ date: JulianDate) -> Vector {
        let T   = date.julianCentury
        let L0  =                    ExtendedMath.frac(0.606433 + 1336.855225 * T)
        let l   = ExtendedMath.pi2 * ExtendedMath.frac(0.374897 + 1325.552410 * T)
        let ls  = ExtendedMath.pi2 * ExtendedMath.frac(0.993133 +   99.997361 * T)
        let D   = ExtendedMath.pi2 * ExtendedMath.frac(0.827361 + 1236.853086 * T)
        let F   = ExtendedMath.pi2 * ExtendedMath.frac(0.259086 + 1342.227825 * T)
        let D2  = 2.0 * D
        let l2  = 2.0 * l
        let F2  = 2.0 * F
        
        let dL  = 22640.0 * sin(l)
                -  4586.0 * sin(l - D2)
                +  2370.0 * sin(D2)
                +   769.0 * sin(l2)
                -   668.0 * sin(ls)
                -   412.0 * sin(F2)
                -   212.0 * sin(l2 - D2)
                -   206.0 * sin(l + ls - D2)
                +   192.0 * sin(l + D2)
                -   165.0 * sin(ls - D2)
                -   125.0 * sin(D)
                -   110.0 * sin(l + ls)
                +   148.0 * sin(l - ls)
                -    55.0 * sin(F2 - D2)
        
        let S   = F + (dL + 412.0 * sin(F2) + 541.0 * sin(ls)) / ExtendedMath.arcs
        let h   = F - D2
        let N   = -526.0 * sin(h)
                +    44.0 * sin(l + h)
                -    31.0 * sin(-l + h)
                -    23.0 * sin(ls + h)
                +    11.0 * sin(-ls + h)
                -    25.0 * sin(-l2 + F)
                +    21.0 * sin(-l + F)
        
        let lMoon = ExtendedMath.pi2 * ExtendedMath.frac(L0 + dL / 1296.0e3)
        let bMoon = (18520.0 * sin(S) + N) / ExtendedMath.arcs
        
        let dt  = 385000.5584
                -  20905.3550 * cos(l)
                -   3699.1109 * cos(D2 - l)
                -   2955.9676 * cos(D2)
                -    569.9251 * cos(l2)
        
        return Vector.ofPolar(lMoon, bMoon, dt)
    }
    
    /// Calculates the geocentric position of the Moon.
    /// - Parameter date: JulianDate to be used.
    /// - Throws: If the position could not be calculated for this date.
    /// - Returns: A Vector containing the Moon position.
    static func position(_ date: JulianDate) throws -> Vector {
        let rotateMatrix = try ExtendedMath.equatorialToEcliptical(date).transpose()
        return try rotateMatrix.multiply(positionEquatorial(date))
    }
    
    /// Calculates the horizontal position of the Moon.
    /// - Parameters:
    ///   - date: JulianDate to be used.
    ///   - lat: Latitude, in radians.
    ///   - lng: Longitude, in radians.
    /// - Throws: If the horizontal position could not be calculated for this date.
    /// - Returns: A Vector containing the Moon position.
    static func positionHorizontal(date: JulianDate, lat: Double, lng: Double) throws -> Vector {
        var mc = try position(date)
        let h = date.getGreenwichMeanSiderealTime() + lng - mc.getPhi()
        return try ExtendedMath.equatorialToHorizontal(tau: h, dec: mc.getTheta(), dist: mc.getR(), lat: lat)
    }
    
    /// Returns the angular radius of the Moon.
    ///
    /// See this Wikipedia entry: https://en.wikipedia.org/wiki/Angular_diameter
    /// - Parameter distance: Distance of the Moon.
    /// - Returns: Angular radius of the Moon, in radians.
    static func angularRadius(_ distance: Double) -> Double {
        return asin(moonMeanRadius / distance)
    }
}
