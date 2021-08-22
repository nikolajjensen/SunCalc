//
//  MoonPositionTest.swift
//  MoonPositionTest
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

import XCTest
@testable import SunCalc

/// Unit tests for MoonPosition.
final class MoonPositionTest: XCTestCase {
    private let error: Double = 0.1
    private let distanceError: Double = 800.0
    
    func testCologne() throws {
        let mp1 = try MoonPosition.compute()
                                    .on(year: 2017, month: 7, day: 12, hour: 13, minute: 28, second: 0)
                                    .at(Locations.cologne)
                                    .timezone(Locations.cologneTz)
                                    .execute()
        
        XCTAssertEqual(mp1.azimuth, 304.8, accuracy: error, "First Cologne Moon azimuth has unexpected value.")
        XCTAssertEqual(mp1.altitude, -39.6, accuracy: error, "First Cologneo Moon altitude has unexpected value.")
        
        let mp2 = try MoonPosition.compute()
                                    .on(year: 2017, month: 7, day: 12, hour: 3, minute: 51, second: 0)
                                    .at(Locations.cologne)
                                    .timezone(Locations.cologneTz)
                                    .execute()
        
        XCTAssertEqual(mp2.azimuth, 179.9, accuracy: error, "Second Cologne Moon azimuth has unexpected value.")
        XCTAssertEqual(mp2.altitude, 25.3, accuracy: error, "Second Cologne Moon altitude has unexpected value.")
        XCTAssertEqual(mp2.distance, 394709.0, accuracy: distanceError, "Second Cologne Moon distance has unexpected value.")
    }
    
    func testAlert() throws {
        let mp1 = try MoonPosition.compute()
                                    .on(year: 2017, month: 7, day: 12, hour: 8, minute: 4, second: 0)
                                    .at(Locations.alert)
                                    .timezone(Locations.alertTz)
                                    .execute()
        
        XCTAssertEqual(mp1.azimuth, 257.5, accuracy: error, "First Alert Moon azimuth has unexpected value.")
        XCTAssertEqual(mp1.altitude, -10.91, accuracy: error, "First Alert Moon altitude has unexpected value.")
        
        let mp2 = try MoonPosition.compute()
                                    .on(year: 2017, month: 7, day: 12, hour: 2, minute: 37, second: 0)
                                    .at(Locations.alert)
                                    .timezone(Locations.alertTz)
                                    .execute()
        
        XCTAssertEqual(mp2.azimuth, 179.8, accuracy: error, "Second Alert Moon azimuth has unexpected value.")
        XCTAssertEqual(mp2.altitude, -5.7, accuracy: error, "Second Alert Moon altitude has unexpected value.")
        XCTAssertEqual(mp2.distance, 394039.0, accuracy: distanceError, "Second Alert Moon distance has unexpected value.")
    }
    
    func testWellington() throws {
        let mp1 = try MoonPosition.compute()
                                    .on(year: 2017, month: 7, day: 12, hour: 4, minute: 7, second: 0)
                                    .at(Locations.wellington)
                                    .timezone(Locations.wellingtonTz)
                                    .execute()
        
        XCTAssertEqual(mp1.azimuth, 311.32, accuracy: error, "First Wellington Moon azimuth has unexpected value.")
        XCTAssertEqual(mp1.altitude, 55.1, accuracy: error, "First Wellington Moon altitude has unexpected value.")
        
        let mp2 = try MoonPosition.compute()
                                    .on(year: 2017, month: 7, day: 12, hour: 2, minute: 17, second: 0)
                                    .at(Locations.wellington)
                                    .timezone(Locations.wellingtonTz)
                                    .execute()
        
        XCTAssertEqual(mp2.azimuth, 0.52, accuracy: error, "Second Wellington Moon azimuth has unexpected value.")
        XCTAssertEqual(mp2.altitude, 63.9, accuracy: error, "Second Wellington Moon altitude has unexpected value.")
        XCTAssertEqual(mp2.distance, 396272.0, accuracy: distanceError, "Second Wellington Moon distance has unexpected value.")
    }
    
    func testPuertoWilliams() throws {
        let mp1 = try MoonPosition.compute()
                                    .on(year: 2017, month: 2, day: 7, hour: 9, minute: 44, second: 0)
                                    .at(Locations.puertoWilliams)
                                    .timezone(Locations.puertoWilliamsTz)
                                    .execute()
        
        XCTAssertEqual(mp1.azimuth, 199.4, accuracy: error, "First Puerto Williams Moon azimuth has unexpected value.")
        XCTAssertEqual(mp1.altitude, -52.7, accuracy: error, "First Puerto Williams Moon altitude has unexpected value.")
        
        let mp2 = try MoonPosition.compute()
                                    .on(year: 2017, month: 2, day: 7, hour: 23, minute: 4, second: 0)
                                    .at(Locations.puertoWilliams)
                                    .timezone(Locations.puertoWilliamsTz)
                                    .execute()
        
        XCTAssertEqual(mp2.azimuth, 0.1, accuracy: error, "Second Puerto Williams Moon azimuth has unexpected value.")
        XCTAssertEqual(mp2.altitude, 16.3, accuracy: error, "Second Puerto Williams Moon altitude has unexpected value.")
        XCTAssertEqual(mp2.distance, 369731.0, accuracy: distanceError, "Second Puerto Williams Moon distance has unexpected value.")
    }
    
    func testSingapore() throws {
        let mp1 = try MoonPosition.compute()
                                    .on(year: 2017, month: 7, day: 12, hour: 5, minute: 12, second: 0)
                                    .at(Locations.singapore)
                                    .timezone(Locations.singaporeTz)
                                    .execute()
        
        XCTAssertEqual(mp1.azimuth, 240.6, accuracy: error, "First Singapore Moon azimuth has unexpected value.")
        XCTAssertEqual(mp1.altitude, 57.1, accuracy: error, "First Singapore Moon altitude has unexpected value.")
        
        let mp2 = try MoonPosition.compute()
                                    .on(year: 2017, month: 7, day: 12, hour: 3, minute: 11, second: 0)
                                    .at(Locations.singapore)
                                    .timezone(Locations.singaporeTz)
                                    .execute()
        
        XCTAssertEqual(mp2.azimuth, 180.0, accuracy: error, "Second Singapore Moon azimuth has unexpected value.")
        XCTAssertEqual(mp2.altitude, 74.1, accuracy: error, "Second Singapore Moon altitude has unexpected value.")
        XCTAssertEqual(mp2.distance, 395621.0, accuracy: distanceError, "Second Singapore Moon distance has unexpected value.")
    }
}

