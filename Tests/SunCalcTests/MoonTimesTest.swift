//
//  MoonTimesTest.swift
//  MoonTimesTest
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

/// Unit tests for MoonTimes.
final class MoonTimesTest: XCTestCase {
    private let error: Double = 60
    
    func testCologne() throws {
        let mt = try MoonTimes.compute().on(year: 2017, month: 7, day: 12).utc().at(Locations.cologne).execute()
        if let rise = mt.rise, let set = mt.set {
            XCTAssertEqual(rise.timeIntervalSince1970, 1499894754.0, accuracy: error, "Wrong Moon rise time for Cologne.")    // Wed Jul 12 2017 21:25:54 GMT+0000
            XCTAssertEqual(set.timeIntervalSince1970, 1499842409.0, accuracy: error, "Wrong Moon set time for Cologne.")    // Wed Jul 12 2017 06:53:29 GMT+0000
        }
        XCTAssertEqual(mt.alwaysUp, false, "Test wrongly concluded that the Moon was always up for Cologne.")
        XCTAssertEqual(mt.alwaysDown, false, "Test wrongly concluded that the Moon was always down for Cologne.")
    }
    
    func testAlert() throws {
        let mt1 = try MoonTimes.compute().on(year: 2017, month: 7, day: 12).utc().at(Locations.alert).oneDay().execute()
        XCTAssertEqual(mt1.alwaysUp, false, "Test wrongly concluded that the Moon was always up for Alert.")
        XCTAssertEqual(mt1.alwaysDown, true, "Test wrongly concluded that the Moon was not always down for Alert.")
        
        let mt2 = try MoonTimes.compute().on(year: 2017, month: 7, day: 12).utc().at(Locations.alert).execute()
        if let rise = mt2.rise, let set = mt2.set {
            XCTAssertEqual(rise.timeIntervalSince1970, 1500011104.0, accuracy: error, "Wrong Moon rise time for Alert.")    // Fri Jul 14 2017 05:45:04 GMT+0000
            XCTAssertEqual(set.timeIntervalSince1970, 1500031603.0, accuracy: error, "Wrong Moon set time for Alert.")    // Fri Jul 14 2017 11:26:43 GMT+0000
        }
        XCTAssertEqual(mt2.alwaysUp, false, "Test wrongly concluded that the Moon was always up for Alert.")
        XCTAssertEqual(mt2.alwaysDown, false, "Test wrongly concluded that the Moon was always down for Alert.")
        
        let mt3 = try MoonTimes.compute().on(year: 2017, month: 7, day: 14).utc().at(Locations.alert).limit(TimeInterval.ofDays(1)).execute()
        if let rise = mt3.rise, let set = mt3.set {
            XCTAssertEqual(rise.timeIntervalSince1970, 1500011104.0, accuracy: error, "Wrong Moon rise time for Alert.")    // Fri Jul 14 2017 05:45:04 GMT+0000
            XCTAssertEqual(set.timeIntervalSince1970, 1500031603.0, accuracy: error, "Wrong Moon set time for Alert.")    // Fri Jul 14 2017 11:26:43 GMT+0000
        }
        XCTAssertEqual(mt3.alwaysUp, false, "Test wrongly concluded that the Moon was always up for Alert.")
        XCTAssertEqual(mt3.alwaysDown, false, "Test wrongly concluded that the Moon was always down for Alert.")
        
        let mt4 = try MoonTimes.compute().on(year: 2017, month: 7, day: 18).utc().at(Locations.alert).oneDay().execute()
        XCTAssertEqual(mt4.alwaysUp, true, "Test wrongly concluded that the Moon was not always up for Alert.")
        XCTAssertEqual(mt4.alwaysDown, false, "Test wrongly concluded that the Moon was always down for Alert.")
        
        let mt5 = try MoonTimes.compute().on(year: 2017, month: 7, day: 18).utc().at(Locations.alert).fullCycle().execute()
        if let rise = mt5.rise, let set = mt5.set {
            XCTAssertEqual(rise.timeIntervalSince1970, 1501156759.0, accuracy: error, "Wrong Moon rise time for Alert.")    // Thu Jul 27 2017 11:59:19 GMT+0000
            XCTAssertEqual(set.timeIntervalSince1970, 1501128429.0, accuracy: error, "Wrong Moon set time for Alert.")    // Thu Jul 27 2017 04:07:09 GMT+0000
        }
        XCTAssertEqual(mt5.alwaysUp, false, "Test wrongly concluded that the Moon was always up for Alert.")
        XCTAssertEqual(mt5.alwaysDown, false, "Test wrongly concluded that the Moon was always down for Alert.")
    }
    
    func testWellington() throws {
        let mt1 = try MoonTimes.compute().on(year: 2017, month: 7, day: 12).utc().at(Locations.wellington).execute()
        if let rise = mt1.rise, let set = mt1.set {
            XCTAssertEqual(rise.timeIntervalSince1970, 1499846752.0, accuracy: error, "Wrong Moon rise time for Wellington.")    // Wed Jul 12 2017 08:05:52 GMT+0000
            XCTAssertEqual(set.timeIntervalSince1970, 1499896657.0, accuracy: error, "Wrong Moon set time for Wellington.")    // Wed Jul 12 2017 21:57:37 GMT+0000
        }
        
        let mt2 = try MoonTimes.compute().on(year: 2017, month: 7, day: 12).timezone("NZ").at(Locations.wellington).execute()
        if let rise = mt2.rise, let set = mt2.set {
            XCTAssertEqual(rise.timeIntervalSince1970, 1499846752.0, accuracy: error, "Wrong Moon rise time for Wellington.")    // Wed Jul 12 2017 08:05:52 GMT+0000
            XCTAssertEqual(set.timeIntervalSince1970, 1499808180.0, accuracy: error, "Wrong Moon set time for Wellington.")    // Tue Jul 11 2017 21:23:00 GMT+0000
        }
    }
    
    func testPuertoWilliams() throws {
        let mt = try MoonTimes.compute().on(year: 2017, month: 7, day: 13).utc().at(Locations.puertoWilliams).execute()
        if let rise = mt.rise, let set = mt.set {
            XCTAssertEqual(rise.timeIntervalSince1970, 1499905889.0, accuracy: error, "Wrong Moon rise time for Puerto Williams.")    // Thu Jul 13 2017 00:31:29 GMT+0000
            XCTAssertEqual(set.timeIntervalSince1970, 1499957316.0, accuracy: error, "Wrong Moon set time for Puerto Williams.")    // Thu Jul 13 2017 14:48:36 GMT+0000
        }
    }
    
    func testSingapore() throws {
        let mt = try MoonTimes.compute().on(year: 2017, month: 7, day: 13).utc().at(Locations.singapore).execute()
        if let rise = mt.rise, let set = mt.set {
            XCTAssertEqual(rise.timeIntervalSince1970, 1499956509.0, accuracy: error, "Wrong Moon rise time for Singapore.")    // Thu Jul 13 2017 14:35:09 GMT+0000
            XCTAssertEqual(set.timeIntervalSince1970, 1499911736.0, accuracy: error, "Wrong Moon set time for Singapore.")    // Thu Jul 13 2017 02:08:56 GMT+0000
        }
    }
    
    func testSequence() throws {
        let acceptableError: Double = 60
        let timeZone = TimeZone(identifier: "UTC")!
        
        let riseBefore = try DateTime(year: 2017, month: 11, day: 25, hour: 12, minute: 0, second: 0, timeZone: timeZone)
        let riseAfter = try DateTime(year: 2017, month: 11, day: 26, hour: 12, minute: 29, second: 0, timeZone: timeZone)
        let setBefore = try DateTime(year: 2017, month: 11, day: 25, hour: 21, minute: 49, second: 0, timeZone: timeZone)
        let setAfter = try DateTime(year: 2017, month: 11, day: 26, hour: 22, minute: 55, second: 0, timeZone: timeZone)
        
        for hour in 0..<24 {
            for minute in 0..<60 {
                let times = try MoonTimes.compute()
                                        .at(Locations.cologne)
                                        .on(year: 2017, month: 11, day: 25, hour: hour, minute: minute, second: 0)
                                        .utc()
                                        .fullCycle()
                                        .execute()
                
                let rise = try XCTUnwrap(times.rise)
                let set = try XCTUnwrap(times.set)
                
                if (hour < 12 || (hour == 12 && minute == 0)) {
                    let diff: Double = abs(TimeInterval.between(rise, riseBefore))
                    XCTAssertLessThan(diff, acceptableError)
                } else {
                    let diff: Double = abs(TimeInterval.between(rise, riseAfter))
                    XCTAssertLessThan(diff, acceptableError)
                }
                
                if (hour < 21 || (hour == 21 && minute <= 49)) {
                    let diff: Double = abs(TimeInterval.between(set, setBefore))
                    XCTAssertLessThan(diff, acceptableError)
                } else {
                    let diff: Double = abs(TimeInterval.between(set, setAfter))
                    XCTAssertLessThan(diff, acceptableError)
                }
            }
        }
    }
}
