//
//  SunTimesTest.swift
//  SunTimesTest
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

/// Unit tests for SunTimes.
final class SunTimesTest: XCTestCase {
    private let error: Double = 3.0
    
    func testCologne() throws {
        let riseTimes: [Twilight: Double] =
        [
            Twilight.astronomical: 1502329458.0,        // Thu Aug 10 2017 01:44:18 GMT+0000
            Twilight.nautical: 1502333097.0,            // Thu Aug 10 2017 02:44:57 GMT+0000
            Twilight.nightHour: 1502335102.0,           // Thu Aug 10 2017 03:18:22 GMT+0000
            Twilight.civil: 1502336041.0,               // Thu Aug 10 2017 03:34:01 GMT+0000
            Twilight.blueHour: 1502336939.0,            // Thu Aug 10 2017 03:48:59 GMT+0000
            Twilight.visual: 1502338309.0,              // Thu Aug 10 2017 04:11:49 GMT+0000
            Twilight.visualLower: 1502338533.0,         // Thu Aug 10 2017 04:15:33 GMT+0000
            Twilight.horizon: 1502338664.0,             // Thu Aug 10 2017 04:17:44 GMT+0000
            Twilight.goldenHour: 1502341113.0           // Thu Aug 10 2017 04:58:33 GMT+0000
        ]
        
        let setTimes: [Twilight: Double] =
        [
            Twilight.goldenHour: 1502388949.0,          // Thu Aug 10 2017 18:15:49 GMT+0000
            Twilight.horizon: 1502391390.0,             // Thu Aug 10 2017 18:56:30 GMT+0000
            Twilight.visualLower: 1502391519.0,         // Thu Aug 10 2017 18:58:39 GMT+0000
            Twilight.visual: 1502391740.0,              // Thu Aug 10 2017 19:02:20 GMT+0000
            Twilight.blueHour: 1502393116.0,            // Thu Aug 10 2017 19:25:16 GMT+0000
            Twilight.civil: 1502394013.0,               // Thu Aug 10 2017 19:40:13 GMT+0000
            Twilight.nightHour: 1502394935.0,           // Thu Aug 10 2017 19:55:35 GMT+0000
            Twilight.nautical: 1502396936.0,            // Thu Aug 10 2017 20:28:56 GMT+0000
            Twilight.astronomical: 1502400523.0         // Thu Aug 10 2017 21:28:43 GMT+0000
        ]
        
        for angle in Twilight.values {
            let times = try SunTimes.compute()
                .at(Locations.cologne)
                .on(year: 2017, month: 8, day: 10)
                .utc()
                .twilight(angle)
                .execute()
            
            if let rise = times.rise {
                XCTAssertEqual(rise.timeIntervalSince1970, riseTimes[angle]!, accuracy: error, "Rise angle has unexpected value.")
            }
            if let set = times.set {
                XCTAssertEqual(set.timeIntervalSince1970, setTimes[angle]!, accuracy: error, "Set angle has unexpected value.")
            }
            if let noon = times.noon {
                XCTAssertEqual(noon.timeIntervalSince1970, 1502365042.0, accuracy: error, "Noon angle has unexpected value.")    // Thu Aug 10 2017 11:37:22 GMT+0000
            }
            if let nadir = times.nadir {
                XCTAssertEqual(nadir.timeIntervalSince1970, 1502408265.0, accuracy: error, "Nadir angle has unexpected value.")    // Thu Aug 10 2017 23:37:45 GMT+0000
            }
            XCTAssertEqual(times.alwaysUp, false, "Wrongly calculated that Sun was always up.")
            XCTAssertEqual(times.alwaysDown, false, "Wrongly calculated that Sun was always down.")
        }
        
        let times = try SunTimes.compute().at(Locations.cologne).on(year: 2017, month: 8, day: 10).utc().twilight(-4.0).execute()
        
        if let rise = times.rise {
            XCTAssertEqual(rise.timeIntervalSince1970, 1502336939.0, accuracy: error, "Rise angle has unexpected value.")    // Thu Aug 10 2017 03:48:59 GMT+0000
        }
        if let set = times.set {
            XCTAssertEqual(set.timeIntervalSince1970, 1502393116.0, accuracy: error, "Set angle has unexpected value.")    // Thu Aug 10 2017 19:25:16 GMT+0000
        }
        if let noon = times.noon {
            XCTAssertEqual(noon.timeIntervalSince1970, 1502365042.0, accuracy: error, "Noon angle has unexpected value.")    // Thu Aug 10 2017 11:37:22 GMT+0000
        }
        if let nadir = times.nadir {
            XCTAssertEqual(nadir.timeIntervalSince1970, 1502408265.0, accuracy: error, "Nadir angle has unexpected value.")    // Thu Aug 10 2017 23:37:45 GMT+0000
        }
        XCTAssertEqual(times.alwaysUp, false, "Wrongly calculated that Sun was always up.")
        XCTAssertEqual(times.alwaysDown, false, "Wrongly calculated that Sun was always down.")
    }
    
    func testAlert() throws {
        let t1 = try SunTimes.compute()
                                .at(Locations.alert)
                                .on(year: 2017, month: 8, day: 10)
                                .utc()
                                .oneDay()
                                .execute()
        // Thu Aug 10 2017 16:13:14 GMT+0000
        assertTimes(t1, nil, nil, 1502381594.0, true)
        
        let t2 = try SunTimes.compute()
                                .at(Locations.alert)
                                .on(year: 2017, month: 9, day: 24)
                                .utc()
                                .execute()
        // Sun Sep 24 2017 09:54:29 GMT+0000, Sun Sep 24 2017 22:02:01 GMT+0000, Sun Sep 24 2017 15:59:16 GMT+0000
        assertTimes(t2, 1506246869.0, 1506290521.0, 1506268756.0)
        
        let t3 = try SunTimes.compute()
                                .at(Locations.alert)
                                .on(year: 2017, month: 2, day: 10)
                                .utc()
                                .oneDay()
                                .execute()
        // Fri Feb 10 2017 16:25:09 GMT+0000
        assertTimes(t3, nil, nil, 1486743909.0, false)
        
        let t4 = try SunTimes.compute()
                                .at(Locations.alert)
                                .on(year: 2017, month: 8, day: 10)
                                .utc()
                                .execute()
        // Wed Sep 06 2017 05:13:15 GMT+0000, Wed Sep 06 2017 03:06:02 GMT+0000, Thu Aug 10 2017 16:13:14 GMT+0000
        assertTimes(t4, 1504674795.0, 1504667162.0, 1502381594.0)
        
        let t5 = try SunTimes.compute()
                                .at(Locations.alert)
                                .on(year: 2017, month: 2, day: 10)
                                .utc()
                                .execute()
        // Mon Feb 27 2017 15:24:18 GMT+0000, Mon Feb 27 2017 17:23:46 GMT+0000, Fri Feb 10 2017 16:25:09 GMT+0000
        assertTimes(t5, 1488209058.0, 1488216226.0, 1486743909.0)
        
        let t6 = try SunTimes.compute()
                                .at(Locations.alert)
                                .on(year: 2017, month: 9, day: 6)
                                .utc()
                                .execute()
        // Wed Sep 06 2017 05:13:15 GMT+0000, Wed Sep 06 2017 03:06:02 GMT+0000, Wed Sep 06 2017 16:05:41 GMT+0000
        assertTimes(t6, 1504674795.0, 1504667162.0, 1504713941.0)
        
        let t7 = try SunTimes.compute()
                                .at(Locations.alert)
                                .on(year: 2020, month: 6, day: 20)
                                .utc()
                                .limit(TimeInterval.ofDays(2))
                                .execute()
        // Sat Jun 20 2020 16:11:02 GMT+0000
        assertTimes(t7, nil, nil, 1592669462.0, true)
    }
    
    func testWellington() throws {
        let t1 = try SunTimes.compute()
                            .at(Locations.wellington)
                            .on(year: 2017, month: 8, day: 10)
                            .timezone(Locations.wellingtonTz)
                            .execute()
        // Wed Aug 09 2017 19:18:33 GMT+0000, Thu Aug 10 2017 05:34:50 GMT+0000, Thu Aug 10 2017 00:26:33 GMT+0000
        assertTimes(t1, 1502306313.0, 1502343290.0, 1502324793.0)
    }
    
    func testPuertoWilliams() throws {
        let t1 = try SunTimes.compute()
                            .at(Locations.puertoWilliams)
                            .on(year: 2017, month: 8, day: 10)
                            .timezone(Locations.puertoWilliamsTz)
                            .execute()
        // Thu Aug 10 2017 12:01:51 GMT+0000, Thu Aug 10 2017 21:10:36 GMT+0000, Thu Aug 10 2017 16:36:07 GMT+0000
        assertTimes(t1, 1502366511.0, 1502399436.0, 1502382967.0)
    }
    
    func testSingapore() throws {
        let t1 = try SunTimes.compute()
                            .at(Locations.singapore)
                            .on(year: 2017, month: 8, day: 10)
                            .timezone(Locations.singaporeTz)
                            .execute()
        // Wed Aug 09 2017 23:05:13 GMT+0000, Thu Aug 10 2017 11:14:56 GMT+0000, Thu Aug 10 2017 05:10:07 GMT+0000
        assertTimes(t1, 1502319913.0, 1502363696.0, 1502341807.0)
    }
    
    func testMartinique() throws {
        let t1 = try SunTimes.compute()
                            .at(Locations.martinique)
                            .on(year: 2019, month: 7, day: 1)
                            .timezone(Locations.martiniqueTz)
                            .execute()
        // Mon Jul 01 2019 09:38:35 GMT+0000, Mon Jul 01 2019 22:37:23 GMT+0000, Mon Jul 01 2019 16:07:57 GMT+0000
        assertTimes(t1, 1561973915.0, 1562020643.0, 1561997277.0)
    }
    
    func testSydney() throws {
        let t1 = try SunTimes.compute()
                            .at(Locations.sydney)
                            .on(year: 2019, month: 7, day: 3)
                            .timezone(Locations.sydneyTz)
                            .execute()
        // Tue Jul 02 2019 21:00:35 GMT+0000, Wed Jul 03 2019 06:58:02 GMT+0000, Wed Jul 03 2019 01:59:18 GMT+0000
        assertTimes(t1, 1562101235.0, 1562137082.0, 1562119158.0)
    }
    
    func testHeight() throws {
        let skytree = try SunTimes.compute()
                            .at(35.710046, 139.810718)
                            .on(year: 2020, month: 6, day: 25)
                            .timezone("Asia/Tokyo")
                            .height(634.0)
                            .execute()
        // Wed Jun 24 2020 19:21:46 GMT+0000, Thu Jun 25 2020 10:05:17 GMT+0000, Thu Jun 25 2020 02:43:28 GMT+0000
        assertTimes(skytree, 1593026506.0, 1593079517.0, 1593053008.0)
    }
    
    // Thanks to @isomeme for providing the test cases for issue #18 on the original Java-project.
    // https://github.com/shred/commons-suncalc/issues/18
    func testJustBeforeJustAfter() throws {
        let shortDuration = 2.0
        let longDuration = 3.0
        
        let param = try SunTimes.compute()
                                    .at(Locations.santaMonica)
                                    .timezone(Locations.santaMonicaTz)
                                    .on(year: 2020, month: 5, day: 3)
        
        let noon = try XCTUnwrap(try param.execute().noon)
        let noonNextDay = try XCTUnwrap(try param.plusDays(1).execute().noon)
        let acceptableError = 65.0
        
        let wellBeforeParam = try SunTimes.compute()
                                    .at(Locations.santaMonica)
                                    .timezone(Locations.santaMonicaTz)
                                    .on(noon.minusMinutes(longDuration))
        let wellBeforeNoon = try XCTUnwrap(try wellBeforeParam.execute().noon)
        XCTAssertLessThan(abs(TimeInterval.between(wellBeforeNoon, noon)), acceptableError, "Difference well before was outside acceptable range.")
        
        let justBeforeParam = try SunTimes.compute()
                                    .at(Locations.santaMonica)
                                    .timezone(Locations.santaMonicaTz)
                                    .on(noon.minusMinutes(shortDuration))
        let justBeforeNoon = try XCTUnwrap(try justBeforeParam.execute().noon)
        XCTAssertLessThan(abs(TimeInterval.between(justBeforeNoon, noon)), acceptableError, "Difference just before was outside acceptable range.")
        
        let wellAfterParam = try SunTimes.compute()
                                    .at(Locations.santaMonica)
                                    .timezone(Locations.santaMonicaTz)
                                    .on(noon.plusMinutes(longDuration))
        let wellAfterNoon = try XCTUnwrap(try wellAfterParam.execute().noon)
        XCTAssertLessThan(abs(TimeInterval.between(wellAfterNoon, noonNextDay)), acceptableError, "Difference well after was outside acceptable range.")
        
        let nadirWellAfterParam = try SunTimes.compute()
                                                    .on(wellAfterNoon)
                                                    .timezone(Locations.santaMonicaTz)
                                                    .at(Locations.santaMonica)
        let nadirWellAfterNoon = try XCTUnwrap(try nadirWellAfterParam.execute().nadir)
        
        let nadirJustBeforeParam = try SunTimes.compute()
                                                    .on(nadirWellAfterNoon.minusMinutes(shortDuration))
                                                    .at(Locations.santaMonica)
                                                    .timezone(Locations.santaMonicaTz)
                                                    
        let nadirJustBeforeNadir = try XCTUnwrap(try nadirJustBeforeParam.execute().nadir)
        
        XCTAssertLessThan(abs(TimeInterval.between(nadirWellAfterNoon, nadirJustBeforeNadir)), acceptableError, "Difference for nadir was outside acceptable range.")
    }
    
    // Thanks to @isomeme for providing the test cases for issue #20 on the original Java-project.
    // https://github.com/shred/commons-suncalc/issues/20
    func testNadirAzimuth() throws {
        try assertNoonNadirPrecision(createDate(2020, 6, 2, 3, 30, Locations.santaMonicaTz), Locations.santaMonica)
        try assertNoonNadirPrecision(createDate(2020, 6, 16, 4, 11, Locations.santaMonicaTz), Locations.santaMonica)
    }
    
    func testSequence() throws {
        let acceptableError = 62.0
        
        let riseBefore = try createDate(2017, 11, 25, 7, 4)
        let riseAfter = try createDate(2017, 11, 26, 7, 6)
        let setBefore = try createDate(2017, 11, 25, 15, 33)
        let setAfter = try createDate(2017, 11, 26, 15, 32)
        
        for hour in 0..<24 {
            for minute in 0..<60 {
                let times = try SunTimes.compute()
                                            .at(Locations.cologne)
                                            .on(year: 2017, month: 11, day: 25, hour: hour, minute: minute, second: 0)
                                            .utc()
                                            .fullCycle()
                                            .execute()
                
                let rise = try XCTUnwrap(times.rise)
                let set = try XCTUnwrap(times.set)
                
                if (hour < 7 || (hour == 7 && minute <= 4)) {
                    let diff = abs(TimeInterval.between(rise, riseBefore))
                    XCTAssertLessThan(diff, acceptableError, "Difference was outside acceptable range.")
                } else {
                    let diff = abs(TimeInterval.between(rise, riseAfter))
                    XCTAssertLessThan(diff, acceptableError, "Difference was outside acceptable range.")
                }
                
                if (hour < 15 || (hour == 15 && minute <= 33)) {
                    let diff = abs(TimeInterval.between(set, setBefore))
                    XCTAssertLessThan(diff, acceptableError, "Difference was outside acceptable range.")
                } else {
                    let diff = abs(TimeInterval.between(set, setAfter))
                    XCTAssertLessThan(diff, acceptableError, "Difference was outside acceptable range.")
                }
            }
        }
    }
    
    private func createDate(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int, _ tz: TimeZone? = nil) throws -> DateTime {
        let timeZone = tz ?? TimeZone(identifier: "UTC")!
        return try DateTime(year: year, month: month, day: day, hour: hour, minute: minute, second: 0, timeZone: timeZone)
    }
    
    private func assertNoonNadirPrecision(_ time: DateTime, _ location: [Double]) throws {
        let sunTimes = try SunTimes.compute()
                                        .at(location)
                                        .on(time)
                                        .execute()
        
        let sunPositionAtNoon = try SunPosition.compute()
                                        .at(location)
                                        .on(sunTimes.noon!)
                                        .execute()
        
        let sunPositionAtNadir = try SunPosition.compute()
                                        .at(location)
                                        .on(sunTimes.nadir!)
                                        .execute()
        
        XCTAssertLessThan(abs(sunPositionAtNoon.azimuth - 180.0), 0.1)
        XCTAssertLessThan(abs(sunPositionAtNadir.azimuth - 360.0), 0.1)
    }
    
    private func assertTimes(_ t: SunTimes, _ rise: Double?, _ set: Double?, _ noon: Double, _ alwaysUp: Bool? = nil) {
        if let tRise = t.rise, let rise = rise {
            XCTAssertEqual(tRise.timeIntervalSince1970, rise, accuracy: error, "Rise time had unexpected value.")
        } else {
            XCTAssertNil(t.rise)
        }
        
        if let tSet = t.set, let set = set {
            XCTAssertEqual(tSet.timeIntervalSince1970, set, accuracy: error, "Set time had unexpected value.")
        }
        
        XCTAssertEqual(try XCTUnwrap(t.noon).timeIntervalSince1970, noon, accuracy: error, "Noon time had unexpected value.")
        
        if let alwaysUp = alwaysUp {
            XCTAssertNotEqual(t.alwaysDown, alwaysUp, "Always up had unexpected value.")
            XCTAssertEqual(t.alwaysUp, alwaysUp, "Always up had unexpected value.")
        } else {
            XCTAssertEqual(t.alwaysDown, false, "Always down had unexpected value.")
            XCTAssertEqual(t.alwaysUp, false, "Always up had unexpected value.")
        }
    }
}
