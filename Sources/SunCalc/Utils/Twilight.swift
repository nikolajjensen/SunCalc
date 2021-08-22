//
//  Twilight.swift
//  Twilight
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

/// Structure for Twilight components.
public struct Twilight: Hashable {
    
    /// The Sun's angle at the twilight position, in degrees.
    public let angle: Double
    
    /// The Sun's angle at the twilight position, in radians.
    public var angleRad: Double {
        return ExtendedMath.toRadians(angle)
    }
    
    /// Returns the angular position.
    ///
    /// 0.0 means center of the Sun, 1.0 means upper edge
    /// of the Sun.
    ///
    /// Atmospheric refraction is taken into account.
    public let position: Double?
    
    /// True if this twilight position is topocentric.
    ///
    /// Then the parallax and the atmospheric refration is taken into account.
    public var isTopocentric: Bool {
        return position != nil
    }
    
    /// Initializer for a Twilight structure.
    /// - Parameters:
    ///   - angle: Sun angle at twilight position, in degrees.
    ///   - position: Angular position of the Sun.
    public init(_ angle: Double, _ position: Double? = nil) {
        self.angle = angle
        self.position = position
    }
}

/// Predefined Twilights.
public extension Twilight {
    
    /// The moment when the visual upper edge of the Sun crosses the horizon.
    ///
    /// This is commonly referred to as "sunrise" and "sunset".
    ///
    /// Atmospheric refraction is taken into account.
    static let visual = Twilight(0.0, 1.0)
    
    /// The moment when the visual lower edge of the Sun crosses the horizon.
    ///
    /// This is the ending of the sunrise and the starting of the sunset.
    ///
    /// Atmospheric refraction is taken into account.
    static let visualLower = Twilight(0.0, -1.0)
    
    /// The moment when the center of the sun crosses the horizon (0°).
    static let horizon = Twilight(0.0)
    
    /// Civil twilight (-6°)
    static let civil = Twilight(-6.0)
    
    /// Nautical twilight (-12°)
    static let nautical = Twilight(-12.0)
    
    /// Astronomical twilight (-18°)
    static let astronomical = Twilight(-18.0)
    
    /// Golden hour (6°)
    ///
    /// The Golden hour is between Golden hour and Blue hour.
    ///
    /// The Magic hour is between Golden hour and Civil darkness.
    static let goldenHour = Twilight(6.0)
    
    /// Blue hour (-4°)
    ///
    /// The Blue hour is between Night hour and Blue hour.
    static let blueHour = Twilight(-4.0)
    
    /// End of Blue hour (-8°)
    ///
    /// "Night hour" is not an official term, but is just a name marking the beginning/end if the Blue hour.
    static let nightHour = Twilight(-8.0)
    
    /// Array of all predefined Twilights.
    static let values = [visual, visualLower, horizon, civil, nautical, astronomical, goldenHour, blueHour, nightHour]
}
