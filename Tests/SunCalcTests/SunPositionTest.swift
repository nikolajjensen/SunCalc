//
//  SunPositionsTest.swift
//  SunPositionsTest
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

/// Unit tests for SunPosition.
final class SunPositionTest: XCTestCase {
    private let error: Double = 0.1
    private let distanceError: Double = 500.0
    
    func testCologne() throws {
        let sp1 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 16, minute: 10, second: 0)
                                .at(Locations.cologne)
                                .timezone(Locations.cologneTz)
                                .execute()
        
        XCTAssertEqual(sp1.azimuth, 239.8, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp1.altitude, 48.6, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp1.trueAltitude, 48.6, accuracy: error, "Wrong true altitude for Sun position.")
        
        let sp2 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 13, minute: 37, second: 0)
                                .at(Locations.cologne)
                                .timezone(Locations.cologneTz)
                                .execute()
        
        XCTAssertEqual(sp2.azimuth, 179.6, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp2.altitude, 61.0, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp2.trueAltitude, 61.0, accuracy: error, "Wrong true altitude for Sun position.")
    }
    
    func testAlert() throws {
        let sp1 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 6, minute: 17, second: 0)
                                .at(Locations.alert)
                                .timezone(Locations.alertTz)
                                .execute()
        
        XCTAssertEqual(sp1.azimuth, 87.5, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp1.altitude, 21.8, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp1.trueAltitude, 21.8, accuracy: error, "Wrong true altitude for Sun position.")
        
        let sp2 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 12, minute: 14, second: 0)
                                .at(Locations.alert)
                                .timezone(Locations.alertTz)
                                .execute()
        
        XCTAssertEqual(sp2.azimuth, 179.7, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp2.altitude, 29.4, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp2.trueAltitude, 29.4, accuracy: error, "Wrong true altitude for Sun position.")
    }
    
    func testWellington() throws {
        let sp1 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 3, minute: 7, second: 0)
                                .at(Locations.wellington)
                                .timezone(Locations.wellingtonTz)
                                .execute()
        
        XCTAssertEqual(sp1.azimuth, 107.3, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp1.altitude, -51.3, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp1.trueAltitude, -51.3, accuracy: error, "Wrong true altitude for Sun position.")
        
        let sp2 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 12, minute: 26, second: 0)
                                .at(Locations.wellington)
                                .timezone(Locations.wellingtonTz)
                                .execute()
        
        XCTAssertEqual(sp2.azimuth, 0.1, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp2.altitude, 26.8, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp2.trueAltitude, 26.8, accuracy: error, "Wrong true altitude for Sun position.")
        
        let sp3 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 7, minute: 50, second: 0)
                                .at(Locations.wellington)
                                .timezone(Locations.wellingtonTz)
                                .execute()
        
        XCTAssertEqual(sp3.azimuth, 60.0, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp3.altitude, 0.6, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp3.trueAltitude, 0.1, accuracy: error, "Wrong true altitude for Sun position.")
    }
    
    func testPuertoWilliams() throws {
        let sp1 = try SunPosition.compute()
                                .on(year: 2017, month: 2, day: 7, hour: 18, minute: 13, second: 0)
                                .at(Locations.puertoWilliams)
                                .timezone(Locations.puertoWilliamsTz)
                                .execute()
        
        XCTAssertEqual(sp1.azimuth, 280.1, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp1.altitude, 25.4, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp1.trueAltitude, 25.4, accuracy: error, "Wrong true altitude for Sun position.")
        
        let sp2 = try SunPosition.compute()
                                .on(year: 2017, month: 2, day: 7, hour: 13, minute: 44, second: 0)
                                .at(Locations.puertoWilliams)
                                .timezone(Locations.puertoWilliamsTz)
                                .execute()
        
        XCTAssertEqual(sp2.azimuth, 0.2, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp2.altitude, 50.2, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp2.trueAltitude, 50.2, accuracy: error, "Wrong true altitude for Sun position.")
    }
    
    func testSingapore() throws {
        let sp1 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 10, minute: 19, second: 0)
                                .at(Locations.singapore)
                                .timezone(Locations.singaporeTz)
                                .execute()
        
        XCTAssertEqual(sp1.azimuth, 60.4, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp1.altitude, 43.5, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp1.trueAltitude, 43.5, accuracy: error, "Wrong true altitude for Sun position.")
        
        let sp2 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 13, minute: 10, second: 0)
                                .at(Locations.singapore)
                                .timezone(Locations.singaporeTz)
                                .execute()
        
        XCTAssertEqual(sp2.azimuth, 0.2, accuracy: error, "Wrong azimuth for Sun position.")
        XCTAssertEqual(sp2.altitude, 69.4, accuracy: error, "Wrong altitude for Sun position.")
        XCTAssertEqual(sp2.trueAltitude, 69.4, accuracy: error, "Wrong true altitude for Sun position.")
    }
    
    func testDistance() throws {
        let sp1 = try SunPosition.compute()
                                .on(year: 2017, month: 1, day: 4, hour: 12, minute: 37, second: 0)
                                .at(Locations.cologne)
                                .timezone(Locations.cologneTz)
                                .execute()
        XCTAssertEqual(sp1.distance, 147097390.6, accuracy: distanceError, "Wrong distance to Sun.")
        
        let sp2 = try SunPosition.compute()
                                .on(year: 2017, month: 4, day: 20, hour: 13, minute: 31, second: 0)
                                .at(Locations.cologne)
                                .timezone(Locations.cologneTz)
                                .execute()
        XCTAssertEqual(sp2.distance, 150181373.3, accuracy: distanceError, "Wrong distance to Sun.")
        
        let sp3 = try SunPosition.compute()
                                .on(year: 2017, month: 7, day: 12, hour: 13, minute: 37, second: 0)
                                .at(Locations.cologne)
                                .timezone(Locations.cologneTz)
                                .execute()
        XCTAssertEqual(sp3.distance, 152088309.0, accuracy: distanceError, "Wrong distance to Sun.")
        
        let sp4 = try SunPosition.compute()
                                .on(year: 2017, month: 10, day: 11, hour: 13, minute: 18, second: 0)
                                .at(Locations.cologne)
                                .timezone(Locations.cologneTz)
                                .execute()
        XCTAssertEqual(sp4.distance, 149380680.0, accuracy: distanceError, "Wrong distance to Sun.")
    }
}
