//
//  TimeParameter.swift
//  TimeParameter
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

/// Time-based parameters used for various calculations.
public protocol TimeParameter {
    associatedtype T
    
    /// A Builder conforming to this protocol must have a 'gettable' DateTime. Used for copying time.
    var dateTime: DateTime { get }
    
    /// Sets the time of calculation.
    /// - Parameters:
    ///   - year: Year of calculation.
    ///   - month: Month of calculation.
    ///   - day: Day of calculation.
    ///   - hour: Hour of calculation.
    ///   - minute: Minute of calculation.
    ///   - second: Second of calculation.
    /// - Throws: If a valid DateTime cannot be constructed based on the parameters.
    /// - Returns: The Builder.
    func on(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) throws -> T
    
    /// Sets the time of calculation.
    /// - Parameter dateTime: The DateTime to use.
    /// - Returns: The Builder.
    func on(_ dateTime: DateTime) -> T
    
    /// Sets the time of calculation to now (in the current timezone).
    /// - Returns: The Builder.
    func now() -> T
    
    /// Sets the time of calculation to last midnight (in the current timezone), from the currently set DateTime.
    /// - Returns: The Builder.
    func midnight() -> T
    
    /// Sets the time of calculation to the Builder's DateTime, plus a number of days.
    /// - Parameter days: Number of days to add.
    /// - Returns: The Builder.
    func plusDays(_ days: Int) -> T
    
    /// Sets the time of calculation to the Builder's DateTime, plus a number of days.
    /// - Parameter days: Number of days to add.
    /// - Returns: The Builder.
    func plusDays(_ days: Double) -> T
    
    /// Sets the timezone.
    ///
    /// Setting the timezone does not change the local time. For example, 6:50 GMT will be 6:50 CET after changing timezone to CET)
    /// - Parameter tz: Timezone to set.
    /// - Returns: The Builder.
    func timezone(_ tz: TimeZone) -> T
    
    /// Sets the time to the same as another Builder that also has a DateTime.
    /// - Parameter l: Another Builder that conforms to the protocol 'TimeParameter'.
    /// - Returns: The Builder.
    func sameTimeAs<P: TimeParameter>(_ t: P) throws -> T
}

public extension TimeParameter {
    
    /// Sets the time of calculation.
    /// - Parameters:
    ///   - year: Year of calculation.
    ///   - month: Month of calculation.
    ///   - day: Day of calculation.
    /// - Throws: If a valid DateTime cannot be constructed based on the parameters.
    /// - Returns: The Builder.
    func on(year: Int, month: Int, day: Int) throws -> T {
        return try on(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
    }
    
    /// Sets the time of calculation.
    /// - Parameters:
    ///   - date: The Date to use.
    ///   - timeZoneID: The ID of the timezone to use.
    /// - Throws: If a valid TimeZone cannot be constructed based on the ID.
    /// - Returns: The Builder.
    func on(_ date: Date, timeZoneID: String) throws -> T {
        let dateTime = DateTime(timeIntervalSince1970: date.timeIntervalSince1970, timeZone: Calendar.current.timeZone)
        var this = on(dateTime)
        this = try timezone(timeZoneID)
        return this
    }
    
    /// Sets the time of calculation.
    /// - Parameters:
    ///   - date: The Date to use.
    ///   - timeZone: The TimeZone to use.
    /// - Returns: The Builder.
    func on(_ date: Date, timeZone: TimeZone) -> T {
        let dateTime = DateTime(timeIntervalSince1970: date.timeIntervalSince1970, timeZone: timeZone)
        return on(dateTime)
    }
    
    /// Sets the time of calculation. The current timezone will be used.
    /// - Parameters:
    ///   - date: The Date to use.
    /// - Returns: The Builder.
    func on(_ date: Date) -> T {
        let dateTime = DateTime(timeIntervalSince1970: date.timeIntervalSince1970, timeZone: Calendar.current.timeZone)
        return on(dateTime)
    }
    
    /// Sets the time of calculation to last midnight from now.
    /// - Returns: The Builder.
    func today() -> T {
        var this = now()
        this = midnight()
        return this
    }
    
    /// Sets the time of calculation to next midnight from now.
    /// - Returns: The Builder.
    func tomorrow() -> T {
        var this = today()
        this = plusDays(1)
        return this
    }
    
    /// Sets the timezone of calculation.
    /// - Parameters:
    ///   - timeZoneID: The ID of the timezone to use.
    /// - Throws: If a valid TimeZone cannot be constructed based on the ID.
    /// - Returns: The Builder.
    func timezone( _ id: String) throws -> T {
        guard let timeZone = TimeZone(identifier: id) else {
            throw SunCalcError.dateManipulationError("Could not determine time zone.")
        }
        
        return timezone(timeZone)
    }
    
    /// Sets the current timezone to the local timezone.
    /// - Returns: The Builder.
    func localTime() -> T {
        return timezone(TimeZone.current)
    }
    
    /// Sets the current timezone to UTC.
    /// - Returns: The Builder
    func utc() throws -> T {
        guard let timeZone = TimeZone(identifier: "UTC") else {
            throw SunCalcError.dateManipulationError("Could not determine time zone UTC.")
        }
        
        return timezone(timeZone)
    }
}
