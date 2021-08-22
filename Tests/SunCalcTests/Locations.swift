//
//  Locations.swift
//  Locations
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

/// Coordinates and timezones for test locations.
struct Locations {
    
    /// Cologne, Germany. A random city in the northern hemisphere.
    static let cologne = [50.938056, 6.956944]
    static let cologneTz = TimeZone(identifier: "Europe/Berlin")!
    
    /// Alert, Nunavut, Canada. The nothernmost place in the world with a permanent population.
    static let alert = [82.5, -62.316667]
    static let alertTz = TimeZone(identifier: "Canada/Eastern")!
    
    /// Wellington, New Zealand. A random city on the southern hemisphere, close to the international date line.
    static let wellington = [-41.2875, 174.776111]
    static let wellingtonTz = TimeZone(identifier: "Pacific/Auckland")!
    
    /// Puerto Williams, Chile. The southernmost town in the world.
    static let puertoWilliams = [-54.933333, -67.616667]
    static let puertoWilliamsTz = TimeZone(identifier: "America/Punta_Arenas")!
    
    /// Singapore. A random city close to the Equator.
    static let singapore = [1.283333, 103.833333]
    static let singaporeTz = TimeZone(identifier: "Asia/Singapore")!
    
    /// Martinique. To test a fix for issue #13 on the Java-version.
    /// https://github.com/shred/commons-suncalc/issues/13
    static let martinique = [14.640725, -61.0112]
    static let martiniqueTz = TimeZone(identifier: "America/Martinique")!
    
    /// Sydney. To test a fix for issue #14 on the Java-version.
    /// https://github.com/shred/commons-suncalc/issues/14
    static let sydney = [-33.744272, 151.231291]
    static let sydneyTz = TimeZone(identifier: "Australia/Sydney")!
    
    /// Santa Monica, CA. To test a fix for issue #18 on the Java-version.
    /// https://github.com/shred/commons-suncalc/issues/18
    static let santaMonica = [34.0, -118.5]
    static let santaMonicaTz = TimeZone(identifier: "America/Los_Angeles")!
}
