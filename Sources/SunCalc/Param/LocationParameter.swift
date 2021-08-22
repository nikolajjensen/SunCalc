//
//  LocationParameter.swift
//  LocationParameter
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

/// Location-based parameters used for various calculations.
public protocol LocationParameter {
    associatedtype T
    
    /// A Builder conforming to this protocol must have a 'gettable' latitude, longitude, and height. Used for copying location.
    var latitude: Double { get }
    var longitude: Double { get }
    var height: Double { get }
    
    /// Sets the latitude.
    /// - Parameter lat: The latitude to set, in degrees.
    /// - Throws: If the latitude is outside the acceptable range.
    /// - Returns: The Builder.
    func latitude(_ lat: Double) throws -> T
    
    /// Sets the longitude.
    /// - Parameter lng: The longitude to set, in degrees.
    /// - Throws: If the longitude is outside the acceptable range.
    /// - Returns: The Builder.
    func longitude(_ lng: Double) throws -> T
    
    /// Sets the height.
    /// - Parameter h: The height to set, in meters above sea level.
    /// - Returns: The Builder.
    func height(_ h: Double) -> T
    
    /// Sets the latitude, longitude, and height to the same as another Builder that also has these.
    /// - Parameter l: Another Builder that conforms to the protocol 'LocationParameter'.
    /// - Returns: The Builder.
    func sameLocationAs<P: LocationParameter>(_ l: P) -> T
}

public extension LocationParameter {
    
    /// Sets the location of calculation to the given coordinates.
    /// - Parameters:
    ///   - lat: The latitude, in degrees.
    ///   - lng: The longitude, in degrees.
    /// - Throws: If the latitude or longitude could not be set.
    /// - Returns: The Builder.
    func at(_ lat: Double, _ lng: Double) throws -> T {
        let _ = try latitude(lat)
        let _ = try longitude(lng)
        return self as! T
    }
    
    /// Sets the location of calculation to the given coordinates.
    /// - Parameters:
    ///   - coords: The latitude and longitude in an array, in degrees. There must be two elements of type Double in this array.
    /// - Throws: If the latitude, longitude, or height could not be set, OR if the input is invalid.
    /// - Returns: The Builder.
    func at(_ coords: [Double]) throws -> T {
        if coords.count != 2 && coords.count != 3 {
            throw SunCalcError.illegalArgumentError("Array must contain 2 or 3 Doubles")
        }
        
        if coords.count == 3 {
            let _ = height(coords[2])
        }
        
        return try at(coords[0], coords[1])
    }
    
    /// Sets the latitude.
    /// - Parameters:
    ///   - d: Degrees. Sign is used for result.
    ///   - m: Minutes. Sign is ignored.
    ///   - s: Seconds and fractions. Sign is ignored.
    /// - Throws: If the latitude could not be set.
    /// - Returns: The Builder.
    func latitude(d: Double, m: Double, s: Double) throws -> T {
        return try latitude(ExtendedMath.dms(d: d, m: m, s: s))
    }
    
    /// Sets the longitude.
    /// - Parameters:
    ///   - d: Degrees. Sign is used for result.
    ///   - m: Minutes. Sign is ignored.
    ///   - s: Seconds and fractions. Sign is ignored.
    /// - Throws: If the longitude could not be set.
    /// - Returns: The Builder.
    func longitude(d: Double, m: Double, s: Double) throws -> T {
        return try longitude(ExtendedMath.dms(d: d, m: m, s: s))
    }
}
