//
//  MoonPhaseTest.swift
//  MoonPhaseTest
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

/// Unit tests for MoonPhase.
final class MoonPhaseTest: XCTestCase {
    private let error: Double = 500.0
    
    func testNewMoon() throws {
        let moonPhase = try MoonPhase.compute()
                                        .on(year: 2017, month: 9, day: 1)
                                        .utc()
                                        .phase(Phase.newMoon)
                                        .execute()
        
        XCTAssertEqual(moonPhase.dateTime.timeIntervalSince1970, 1505885371.0, "Wrong date for new moon.")    // Wed Sep 20 2017 05:29:31 GMT+0000
        XCTAssertEqual(moonPhase.distance, 382740.0, accuracy: error, "Wrong Moon distance.")
    }
    
    func testFirstQuarterMoon() throws {
        let moonPhase = try MoonPhase.compute()
                                        .on(year: 2017, month: 9, day: 1)
                                        .utc()
                                        .phase(Phase.firstQuarter)
                                        .execute()
        
        XCTAssertEqual(moonPhase.dateTime.timeIntervalSince1970, 1506567160.0, "Wrong date for first quarter moon.")    // Thu Sep 28 2017 02:52:40 GMT+0000
        XCTAssertEqual(moonPhase.distance, 403894.0, accuracy: error, "Wrong Moon distance.")
    }
    
    func testFullMoon() throws {
        let moonPhase = try MoonPhase.compute()
                                        .on(year: 2017, month: 9, day: 1)
                                        .utc()
                                        .phase(Phase.fullMoon)
                                        .execute()
        
        XCTAssertEqual(moonPhase.dateTime.timeIntervalSince1970, 1504681664.0, "Wrong date for full moon.")    // Wed Sep 06 2017 07:07:44 GMT+0000
        XCTAssertEqual(moonPhase.distance, 384364.0, accuracy: error, "Wrong Moon distance.")
    }
    
    func testLastQuarterMoon() throws {
        let moonPhase = try MoonPhase.compute()
                                        .on(year: 2017, month: 9, day: 1)
                                        .utc()
                                        .phase(Phase.lastQuarter)
                                        .execute()
        
        XCTAssertEqual(moonPhase.dateTime.timeIntervalSince1970, 1505284114.0, "Wrong date for last quarter moon.")    // Wed Sep 13 2017 06:28:34 GMT+0000
        XCTAssertEqual(moonPhase.distance, 369899.0, accuracy: error, "Wrong Moon distance.")
    }
    
    func testToPhase() {
        // Exact angles
        XCTAssertEqual(Phase.toPhase(0.0), Phase.newMoon, "Wrong angle for new moon phase.")
        XCTAssertEqual(Phase.toPhase(45.0), Phase.waxingCrescent, "Wrong angle for waxing crescent phase.")
        XCTAssertEqual(Phase.toPhase(90.0), Phase.firstQuarter, "Wrong angle for first quarter phase.")
        XCTAssertEqual(Phase.toPhase(135.0), Phase.waxingGibbous, "Wrong angle for waxing gibbous phase.")
        XCTAssertEqual(Phase.toPhase(180.0), Phase.fullMoon, "Wrong angle for full moon phase.")
        XCTAssertEqual(Phase.toPhase(225.0), Phase.waningGibbous, "Wrong angle for waning gibbous phase.")
        XCTAssertEqual(Phase.toPhase(270.0), Phase.lastQuarter, "Wrong angle for last quarter phase.")
        XCTAssertEqual(Phase.toPhase(315.0), Phase.waningCrescent, "Wrong angle for waning crescent phase.")
        
        // Out of range angles (normalization test)
        XCTAssertEqual(Phase.toPhase(360.0), Phase.newMoon, "Wrong phase for out of range angle corresponding to new moon phase.")
        XCTAssertEqual(Phase.toPhase(720.0), Phase.newMoon, "Wrong phase for out of range angle corresponding to new moon phase.")
        XCTAssertEqual(Phase.toPhase(-360.0), Phase.newMoon, "Wrong phase for out of range angle corresponding to new moon phase.")
        XCTAssertEqual(Phase.toPhase(-720.0), Phase.newMoon, "Wrong phase for out of range angle corresponding to new moon phase.")
        XCTAssertEqual(Phase.toPhase(855.0), Phase.waxingGibbous, "Wrong phase for out of range angle corresponding to waxing gibbous phase.")
        XCTAssertEqual(Phase.toPhase(-585.0), Phase.waxingGibbous, "Wrong phase for out of range angle corresponding to waxing gibbous phase.")
        XCTAssertEqual(Phase.toPhase(-945.0), Phase.waxingGibbous, "Wrong phase for out of range angle corresponding to waxing gibbous phase.")
        
        // Close to boundary
        XCTAssertEqual(Phase.toPhase(22.4), Phase.newMoon, "Wrong phase boundary range angle corresponding to new moon phase.")
        XCTAssertEqual(Phase.toPhase(67.4), Phase.waxingCrescent, "Wrong phase boundary range angle corresponding to waxing crescent phase.")
        XCTAssertEqual(Phase.toPhase(112.4), Phase.firstQuarter, "Wrong phase boundary range angle corresponding to first quarter phase.")
        XCTAssertEqual(Phase.toPhase(157.4), Phase.waxingGibbous, "Wrong phase boundary range angle corresponding to waxing gibbous phase.")
        XCTAssertEqual(Phase.toPhase(202.4), Phase.fullMoon, "Wrong phase boundary range angle corresponding to full moon phase.")
        XCTAssertEqual(Phase.toPhase(247.4), Phase.waningGibbous, "Wrong phase boundary range angle corresponding to waning gibbous phase.")
        XCTAssertEqual(Phase.toPhase(292.4), Phase.lastQuarter, "Wrong phase boundary range angle corresponding to last quarter phase.")
        XCTAssertEqual(Phase.toPhase(337.4), Phase.waningCrescent, "Wrong phase boundary range angle corresponding to waning crescent phase.")
        XCTAssertEqual(Phase.toPhase(382.4), Phase.newMoon, "Wrong phase boundary range angle corresponding to new moon phase.")
    }
}
