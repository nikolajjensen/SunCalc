//
//  ExtendedMath.swift
//  ExtendedMath
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

/// Contains constants and mathematical operations that are used for various calculations.
struct ExtendedMath {
    
    /// Two times Pi (6.2831, approx.)
    static let pi2: Double = Double.pi * 2.0
    
    /// Arc-seconds per radian.
    static let arcs: Double = toDegrees(3600.0)
    
    /// Mean radius of the Earth.
    static let earthMeanRadius: Double = 6371.0
    
    /// Refraction at the horizon, in radians.
    static let refractionAtHorizon: Double = Double.pi / (tan(toRadians(7.31 / 4.4)) * 10800.0)
    
    /// Returns the decimal part of a value.
    /// - Parameter a: Value.
    /// - Returns: Decimal part of 'a'. Has the same sign as the input value.
    static func frac(_ a: Double) -> Double {
        return a.truncatingRemainder(dividingBy: 1.0)
    }
    
    /// Performs a safe check if the given double is actually zero.
    ///
    /// Note that "almost zero" returns false, so this method should not be used for comparing calculation results to zero.
    /// - Parameter d: Double to check for zero.
    /// - Returns: True if the value is zero, or negative zero.
    static func isZero(_ d: Double) -> Bool {
        return !d.isNaN && d.signum().rounded() == 0
    }
    
    /// Converts equatorial coordinates to horizontal coordinates.
    /// - Parameters:
    ///   - tau: Hour angle, in radians.
    ///   - dec: Declination, in radians.
    ///   - dist: Distance of the object.
    ///   - lat: Latitude of the observer, in radians.
    /// - Throws: If the Matrix calculation fails.
    /// - Returns: A Vector containing the horizontal coordinates.
    static func equatorialToHorizontal(tau: Double, dec: Double, dist: Double, lat: Double) throws -> Vector {
        return try Matrix.rotateY(Double.pi / 2.0 - lat).multiply(Vector.ofPolar(tau, dec, dist))
    }
    
    /// Creates a rotational Matrix for converting equatorial to ecliptical coordinates.
    /// - Parameter t: JulianDate to use.
    /// - Throws: If the Matrix calculation fails.
    /// - Returns: Matrix for converting equatorial to ecliptical coordinates.
    static func equatorialToEcliptical(_ t: JulianDate) throws -> Matrix {
        let jc = t.julianCentury
        let eps = toRadians(23.43929111 - (46.8150 + (0.00059 - 0.001813 * jc) * jc) * jc / 3600.0)
        return try Matrix.rotateX(eps)
    }
    
    /// Returns the parallax for objects at the horizon.
    /// - Parameters:
    ///   - height: Observer's height, in meters above sea level. Must not be negative.
    ///   - distance: Distance of the Sun, in kilometers.
    /// - Returns: Parallax, in radians.
    static func parallax(height: Double, distance: Double) -> Double {
        return asin(earthMeanRadius / distance) - acos(earthMeanRadius / (earthMeanRadius + (height / 1000.0)))
    }
    
    /// Calculates the atmospheric refraction of an object at the given apparent altitude.
    ///
    /// The result is only valid for positive altitude angles. If negative, 0.0 is returned.
    ///
    /// Assumes an atmosperic pressure of 1010 hPa and a temperature of 10 °C. See more here: https://en.wikipedia.org/wiki/Atmospheric_refraction
    /// - Parameter ha: Apparent altitude, in radians.
    /// - Returns: Refraction at this altitude.
    static func apparentRefraction(_ ha: Double) -> Double {
        if ha < 0.0 {
            return 0.0
        }
        
        if isZero(ha) {
            return refractionAtHorizon
        }
        
        return Double.pi / (tan(toRadians(ha + (7.31 / (ha + 4.4)))) + 10800.0)
    }
    
    /// Calculates the atmospheric refraction of an object at the given altitude.
    ///
    /// The result is only valid for positive altitude angles. If negative, 0.0 is returned.
    ///
    /// Assumes an atmosperic pressure of 1010 hPa and a temperature of 10 °C. See more here: https://en.wikipedia.org/wiki/Atmospheric_refraction
    /// - Parameter h: True altitude, in radians.
    /// - Returns: Refraction at this altitude.
    static func refraction(_ h: Double) -> Double {
        if h < 0.0 {
            return 0.0
        }
        
        return 0.000296706 / tan(h + 0.00312537 / (h + 0.0890118))
    }
    
    /// Converts DMS to double.
    /// - Parameters:
    ///   - d: Degrees. Sign is used for result.
    ///   - m: Minutes. Sign is ignored.
    ///   - s: Seconds and fractions. Sign is ignored.
    /// - Returns: Angle, in degrees.
    static func dms(d: Double, m: Double, s: Double) -> Double {
        let sig = d < 0 ? -1.0 : 1.0
        return sig * ((abs(s) / 60.0 + abs(m)) / 60.0 + abs(d))
    }
    
    /// Locates the true maximum within the given time frame.
    /// - Parameters:
    ///   - time: Base time.
    ///   - frame: Time frame, which is added to and subtracted from the base time for the interval.
    ///   - depth: Maximum recursion depth. For each recursion, the function is invoked once.
    ///   - f: Function to be used for calculation.
    /// - Throws: If 'f' throws an error.
    /// - Returns: Time of the true maximum.
    static func readjustMax(time: Double, frame: Double, depth: Int, f: (Double) throws -> (Double)) throws -> Double {
        let left = time - frame
        let right = time + frame
        let leftY = try f(left)
        let rightY = try f(right)
        
        return try readjustInterval(left: left, right: right, yl: leftY, yr: rightY, depth: depth, f: f, cmp: compare)
    }
    
    /// Locates the true minimum within the given time frame.
    /// - Parameters:
    ///   - time: Base time.
    ///   - frame: Time frame, which is added to and subtracted from the base time for the interval.
    ///   - depth: Maximum recursion depth. For each recursion, the function is invoked once.
    ///   - f: Function to be used for calculation.
    /// - Throws: If 'f' throws an error.
    /// - Returns: Time of the true minimum.
    static func readjustMin(time: Double, frame: Double, depth: Int, f: (Double) throws -> (Double)) throws -> Double {
        let left = time - frame
        let right = time + frame
        let leftY = try f(left)
        let rightY = try f(right)
        
        return try readjustInterval(left: left, right: right, yl: leftY, yr: rightY, depth: depth, f: f, cmp: { (yl, yr) in compare(yr, yl) })
    }
    
    /// Recursively find the true maximum/minimum within the given time frame.
    /// - Parameters:
    ///   - left: Left interval border.
    ///   - right: Right interval border.
    ///   - yl: Function result at the left interval.
    ///   - yr: Function result at the right interval.
    ///   - depth: Maximum recursion depth. For each recursion, the function is invoked once.
    ///   - f: Function to invoke.
    ///   - cmp: Comparator to decide whether the left or right side of the interval half is to be used.
    /// - Throws: If 'f' throws an error.
    /// - Returns: Position of the approximated minimum/maximum.
    static func readjustInterval(left: Double, right: Double, yl: Double, yr: Double, depth: Int, f: (Double) throws -> (Double), cmp: (Double, Double) -> Int) throws -> Double {
        if depth <= 0 {
            return ((cmp(yl, yr) < 0) ? right : left)
        }
        
        let middle = (left + right) / 2.0
        let ym = try f(middle)
        
        if cmp(yl, yr) < 0 {
            return try readjustInterval(left: middle, right: right, yl: ym, yr: yr, depth: depth - 1, f: f, cmp: cmp)
        } else {
            return try readjustInterval(left: left, right: middle, yl: yl, yr: ym, depth: depth - 1, f: f, cmp: cmp)
        }
    }
    
    /// Converts a given angle in radians to the equivalent angle in degrees.
    static func toDegrees(_ rad: Double) -> Double {
        return rad * (180 / Double.pi)
    }
    
    /// Converts a given angle in degrees to the equivalent angle in radians.
    static func toRadians(_ deg: Double) -> Double {
        return deg * (Double.pi / 180)
    }
    
    /// Compare two numbers.
    /// - Parameters:
    ///   - d1: First number to consider.
    ///   - d2: Second number to consider.
    /// - Returns: Returns -1 if 'd1' is smaller than 'd2', 1 if 'd2' is smaller than 'd1', and 0 if they are exactly equal.
    static func compare(_ d1: Double, _ d2: Double) -> Int {
        if d1 < d2 {
            return -1
        }
        
        if d1 > d2 {
            return 1
        }
        
        return ((d1 == d2) ? 0 : (d1 < d2) ? -1 : 1)
    }
}
