//
//  ExamplesTest.swift
//  ExamplesTest
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

/// These are some examples that are meant to be executed manually.
final class ExamplesTest: XCTestCase {
    func testTimezone() throws {
        // This test takes place in the user's default TimeZone.
        
        let paris = try SunTimes.compute()
                                    .on(year: 2020, month: 5, day: 1)
                                    .latitude(d: 48, m: 51, s: 24.0)
                                    .longitude(d: 2, m: 21, s: 6.0)
                                    .execute()
        
        let riseParis = try XCTUnwrap(paris.rise)
        let setParis = try XCTUnwrap(paris.set)
        
        print("Sunrise in Paris: \(riseParis)")
        print("Sunset in Paris: \(setParis)")
        
        let newYork = try SunTimes.compute()
                                    .on(year: 2020, month: 5, day: 1)
                                    .at(40.712778, -74.005833)
                                    .execute()
        
        let riseNY = try XCTUnwrap(newYork.rise)
        let setNY = try XCTUnwrap(newYork.set)
        
        print("Sunrise in New York: \(riseNY)")
        print("Sunset in New York: \(setNY)")
        
        let newYorkTZ = try SunTimes.compute()
                                    .on(year: 2020, month: 5, day: 1)
                                    .timezone("America/New_York")
                                    .at(40.712778, -74.005833)
                                    .execute()
        
        let riseNYTZ = try XCTUnwrap(newYorkTZ.rise)
        let setNYTZ = try XCTUnwrap(newYorkTZ.set)
        
        print("Sunrise in New York: \(riseNYTZ)")
        print("Sunset in New York: \(setNYTZ)")
    }
    
    func testTimeWindow() throws {
        let canadaCoords = [82.5, -62.316667]
        let canadaTz = TimeZone(identifier: "Canada/Eastern")!
        
        let march = try SunTimes.compute()
                                    .on(year: 2020, month: 3, day: 15)
                                    .at(canadaCoords)
                                    .timezone(canadaTz)
                                    .execute()
        
        let marchRise = try XCTUnwrap(march.rise)
        let marchSet = try XCTUnwrap(march.set)
        
        print("Sunrise: \(marchRise)")
        print("Sunset: \(marchSet)")
        
        let june = try SunTimes.compute()
                                    .on(year: 2020, month: 6, day: 15)
                                    .at(canadaCoords)
                                    .timezone(canadaTz)
                                    .execute()
        
        let juneRise = try XCTUnwrap(june.rise)
        let juneSet = try XCTUnwrap(june.set)
        
        print("Sunrise: \(juneRise)")
        print("Sunset: \(juneSet)")
        
        let june15OnlyCycle = try SunTimes.compute()
                                    .on(year: 2020, month: 6, day: 15)
                                    .at(canadaCoords)
                                    .timezone(canadaTz)
                                    .limit(TimeInterval.ofHours(24))
                                    .execute()
        
        print("Sunrise: \(june15OnlyCycle.rise as Optional)")
        print("Sunset: \(june15OnlyCycle.set as Optional)")
        
        print("Sun is up all day: \(june15OnlyCycle.alwaysUp)")
        print("Sun is down all day: \(june15OnlyCycle.alwaysDown)")
    }
    
    func testParameterRecycling() throws {
        let cologneCoords = [50.938056, 6.956944]
        
        let parameters = try MoonTimes.compute()
                                        .at(cologneCoords)
                                        .midnight()
        
        let today = try parameters.execute()
        if let rise = today.rise {
            print("Today, the moon rises in Cologne at: \(rise)")
        }
        
        let _ = parameters.tomorrow()
        let tomorrow = try parameters.execute()
        if let riseTomorrow = tomorrow.rise, let riseToday = today.rise {
            print("Tomorrow, the moon rises in Cologne at: \(riseTomorrow)")
            print("But today, the moon still rises at: \(riseToday)")
        }
    }
    
    func testParameterRecyclingLoop() throws {
        let parameters = try MoonIllumination.compute().on(year: 2020, month: 1, day: 1)
        
        for i in 1...31 {
            let percent = try parameters.execute().fraction * 100
            print("On January \(i) the moon was \(String(format: "%.2f", percent))% lit.")
            let _ = parameters.plusDays(1)
        }
    }
    
    func testGoldenHour() throws {
        let base = try SunTimes.compute()
                                    .at(1.283333, 103.833333)
                                    .on(year: 2020, month: 6, day: 1)
                                    .timezone("Asia/Singapore")
        
        for i in 0..<4 {
            let blue = try base.copy()
                                    .plusDays(i * 7)
                                    .twilight(Twilight.blueHour)
                                    .execute()
            
            let golden = try base.copy()
                                    .plusDays(i * 7)
                                    .twilight(Twilight.goldenHour)
                                    .execute()
            
            if let blueRise = blue.rise {
                print("Morning golden hour starts at: \(blueRise)")
            }
            
            if let goldenRise = golden.rise {
                print("Morning golden hour ends at: \(goldenRise)")
            }
            
            if let goldenSet = golden.set {
                print("Evening golden hour starts at: \(goldenSet)")
            }
            
            if let blueSet = blue.set {
                print("Evening golden hour ends at: \(blueSet)")
            }
            
            print("=====")
        }
    }
    
    func testMoonPhase() throws {
        var dateTime = try DateTime(year: 2023, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        let parameters = MoonPhase.compute().phase(Phase.fullMoon)
        
        while true {
            let moonPhase = try parameters
                                    .on(dateTime)
                                    .execute()
            let nextFullMoon = moonPhase
                                    .dateTime
                                    .toLocalDate()
            
            if try nextFullMoon.getYear() == 2024 {
                break   // We've reached the next year.
            }
            
            print(nextFullMoon, terminator: " ")
            
            if moonPhase.isMicroMoon {
                print(" (micromoon)", terminator: " ")
            } else if moonPhase.isSuperMoon {
                print(" (supermoon)", terminator: " ")
            }
            print("")
            
            dateTime = nextFullMoon.plusDays(1)
        }
    }
    
    func testPositions() throws {
        let sunParam = try SunPosition.compute()
                                    .at(35.689722, 139.692222)
                                    .timezone("Asia/Tokyo")
                                    .on(year: 2018, month: 11, day: 13, hour: 10, minute: 3, second: 24)
        
        let moonParam = try MoonPosition.compute()
                                            .sameLocationAs(sunParam)
                                            .sameTimeAs(sunParam)
        
        let sun = try sunParam.execute()
        print("The Sun can be seen \(sun.azimuth)° clockwise from North and \(sun.altitude)° above the horizon.")
        print("It is about \(sun.distance)km away right now.")
        
        let moon = try moonParam.execute()
        print("The Moon can be seen \(moon.azimuth)° clockwise from North and \(moon.altitude)° above the horizon.")
        print("It is about \(moon.distance)km away right now.")
    }
}
