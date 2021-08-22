//
//  MoonIlluminationTest.swift
//  MoonIlluminationTest
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

/// Unit tests for MoonIllumination.
final class MoonIlluminationTest: XCTestCase {
    private let error: Double = 0.1
    
    func testNewMoon() throws {
        let moonIllumination = try MoonIllumination.compute()
                                                        .on(year: 2017, month: 6, day: 24, hour: 4, minute: 30, second: 0)
                                                        .timezone(Locations.cologneTz)
                                                        .execute()
        
        XCTAssertEqual(moonIllumination.fraction, 0.0, accuracy: error, "Wrong Moon illumination fraction.")
        XCTAssertEqual(moonIllumination.phase, 176.0, accuracy: error, "Wrong Moon phase.")
        XCTAssertEqual(moonIllumination.angle, 1.8, accuracy: error, "Wrong Moon illumination angle.")
        XCTAssertEqual(moonIllumination.closestPhase, Phase.newMoon, "Wrong Moon phase.")
    }
    
    func testWaxingHalfMoon() throws {
        let moonIllumination = try MoonIllumination.compute()
                                                        .on(year: 2017, month: 7, day: 1, hour: 2, minute: 51, second: 0)
                                                        .timezone(Locations.cologneTz)
                                                        .execute()
        
        XCTAssertEqual(moonIllumination.fraction, 0.5, accuracy: error, "Wrong Moon illumination fraction.")
        XCTAssertEqual(moonIllumination.phase, -90.0, accuracy: error, "Wrong Moon phase.")
        XCTAssertEqual(moonIllumination.angle, -66.9, accuracy: error, "Wrong Moon illumination angle.")
        XCTAssertEqual(moonIllumination.closestPhase, Phase.firstQuarter, "Wrong Moon phase.")
    }
    
    func testFullMoon() throws {
        let moonIllumination = try MoonIllumination.compute()
                                                        .on(year: 2017, month: 7, day: 9, hour: 6, minute: 6, second: 0)
                                                        .timezone(Locations.cologneTz)
                                                        .execute()
        
        XCTAssertEqual(moonIllumination.fraction, 1.0, accuracy: error, "Wrong Moon illumination fraction.")
        XCTAssertEqual(moonIllumination.phase, -3.2, accuracy: error, "Wrong Moon phase.")
        XCTAssertEqual(moonIllumination.angle, -7.0, accuracy: error, "Wrong Moon illumination angle.")
        XCTAssertEqual(moonIllumination.closestPhase, Phase.fullMoon, "Wrong Moon phase.")
    }
    
    func testWaningHalfMoon() throws {
        let moonIllumination = try MoonIllumination.compute()
                                                        .on(year: 2017, month: 7, day: 16, hour: 21, minute: 25, second: 0)
                                                        .timezone(Locations.cologneTz)
                                                        .execute()
        
        XCTAssertEqual(moonIllumination.fraction, 0.5, accuracy: error, "Wrong Moon illumination fraction.")
        XCTAssertEqual(moonIllumination.phase, 90, accuracy: error, "Wrong Moon phase.")
        XCTAssertEqual(moonIllumination.angle, 68.1, accuracy: error, "Wrong Moon illumination angle.")
        XCTAssertEqual(moonIllumination.closestPhase, Phase.lastQuarter, "Wrong Moon phase.")
    }
}
