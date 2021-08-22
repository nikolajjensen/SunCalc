//
//  Phase.swift
//  Phase
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

/// Structure for Phase components.
public struct Phase: Equatable {
    public let angle: Double
    public let angleRad: Double
    
    public init(_ angle: Double) {
        self.angle = angle
        self.angleRad = ExtendedMath.toRadians(angle)
    }
    
    /// Converts an angle to the closest matching Moon phase.
    /// - Parameter angle: Moon phae angle, in degrees. 0 = New Moon, 180 = Full Moon. Angles outside the [0,360) range are normalized into that range.
    /// - Returns: Closest Phase that is matching that angle.
    public static func toPhase(_ angle: Double) -> Phase {
        var normalized = angle.truncatingRemainder(dividingBy: 360)
        if normalized < 0.0 {
            normalized += 360.0
        }
        
        if (normalized < 22.5) {
            return newMoon
        }
        if (normalized < 67.5) {
            return waxingCrescent
        }
        if (normalized < 112.5) {
            return firstQuarter
        }
        if (normalized < 157.5) {
            return waxingGibbous
        }
        if (normalized < 202.5) {
            return fullMoon
        }
        if (normalized < 247.5) {
            return waningGibbous
        }
        if (normalized < 292.5) {
            return lastQuarter
        }
        if (normalized < 337.5) {
            return waningCrescent
        }
        return newMoon
    }
}

/// Predefined Moon phases.
public extension Phase {

    /// New Moon.
    static let newMoon = Phase(0.0)
    
    /// Waxing crescent Moon.
    static let waxingCrescent = Phase(45.0)
    
    /// Waxing half Moon.
    static let firstQuarter = Phase(90.0)
    
    /// Waxing gibbous Moon.
    static let waxingGibbous = Phase(135.0)
    
    /// Full moon.
    static let fullMoon = Phase(180.0)
    
    /// Waning gibbous Moon.
    static let waningGibbous = Phase(225.0)
    
    /// Waning half Moon.
    static let lastQuarter = Phase(270.0)
    
    /// Waxing crescent Moon.
    static let waningCrescent = Phase(315.0)
}
