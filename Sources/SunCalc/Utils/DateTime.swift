//
//  DateTime.swift
//  DateTime
//
//  Copyright © 2021 Nikolaj Banke Jensen
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//

import Foundation

/// Structure for DateTime components.
public struct DateTime: CustomStringConvertible {
    
    // Time interval since epoch. Adjusted for time zone.
    public var timeIntervalSince1970: Double
    
    // Time zone for the Date Time structure.
    public var timeZone: TimeZone
    
    public init(timeIntervalSince1970: Double, timeZone: TimeZone) {
        self.timeIntervalSince1970 = timeIntervalSince1970
        self.timeZone = timeZone
    }
    
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, timeZone: TimeZone? = nil) throws {
        let tz = timeZone ?? Calendar.current.timeZone
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.timeZone = tz
        
        guard let date = Calendar.current.date(from: dateComponents) else {
            throw SunCalcError.dateManipulationError("Could not construct date from given date components: \(dateComponents)")
        }
        
        self.timeIntervalSince1970 = date.timeIntervalSince1970
        self.timeZone = tz
    }
    
    /// Description of the DateTime structure.
    /// Insipired by: https://stackoverflow.com/a/26852101
    public var description: String {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.long
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = timeZone
        let finalDate = dateFormatter.string(from: date)
        return finalDate
    }
    
    /// Returns a new DateTime of the current time, in the current time zone.
    public static func now() -> DateTime {
        return DateTime(timeIntervalSince1970: Date().timeIntervalSince1970, timeZone: Calendar.current.timeZone)
    }
    
    /// Returns a new DateTime of the time at the last midnight, in the current time zone.
    public static func midnight() -> DateTime {
        let now = DateTime.now()
        let lastMidnight = Calendar.current.startOfDay(for: Date.init(timeIntervalSince1970: now.timeIntervalSince1970))
        return DateTime(timeIntervalSince1970: lastMidnight.timeIntervalSince1970, timeZone: Calendar.current.timeZone)
    }
    
    /// Returns a new DateTime by adding the given seconds to this DateTime.
    /// - Parameter seconds: Seconds to add.
    /// - Returns: A new DateTime which is the sum of this DateTime and the parameter.
    public func plusSeconds(_ seconds: Double) -> DateTime {
        let total = timeIntervalSince1970 + seconds
        return DateTime(timeIntervalSince1970: total, timeZone: timeZone)
    }
    
    /// Returns a new DateTime by adding the given minutes to this DateTime.
    /// - Parameter seconds: Minutes to add.
    /// - Returns: A new DateTime which is the sum of this DateTime and the parameter.
    public func plusMinutes(_ minutes: Double) -> DateTime {
        let total = timeIntervalSince1970 + minutes * 60
        return DateTime(timeIntervalSince1970: total, timeZone: timeZone)
    }
    
    /// Returns a new DateTime by adding the given hours to this DateTime.
    /// - Parameter seconds: Hours to add.
    /// - Returns: A new DateTime which is the sum of this DateTime and the parameter.
    public func plusHours(_ hours: Double) -> DateTime {
        let total = timeIntervalSince1970 + hours * 60 * 60
        return DateTime(timeIntervalSince1970: total, timeZone: timeZone)
    }
    
    /// Returns a new DateTime by adding the given days to this DateTime.
    /// - Parameter seconds: Days to add.
    /// - Returns: A new DateTime which is the sum of this DateTime and the parameter.
    public func plusDays(_ days: Double) -> DateTime {
        let total = timeIntervalSince1970 + days * 60 * 60 * 24
        return DateTime(timeIntervalSince1970: total, timeZone: timeZone)
    }
    
    /// Returns a new DateTime by subtracting the given seconds from this DateTime.
    /// - Parameter seconds: Seconds to subtract.
    /// - Returns: A new DateTime which is this DateTime minus the parameter.
    public func minusSeconds(_ seconds: Double) -> DateTime {
        let total = timeIntervalSince1970 - seconds
        return DateTime(timeIntervalSince1970: total, timeZone: timeZone)
    }
    
    /// Returns a new DateTime by subtracting the given minutes from this DateTime.
    /// - Parameter seconds: Minutes to subtract.
    /// - Returns: A new DateTime which is this DateTime minus the parameter.
    public func minusMinutes(_ minutes: Double) -> DateTime {
        let total = timeIntervalSince1970 - minutes * 60
        return DateTime(timeIntervalSince1970: total, timeZone: timeZone)
    }
    
    /// Returns a new DateTime by subtracting the given hours from this DateTime.
    /// - Parameter seconds: Hours to subtract.
    /// - Returns: A new DateTime which is this DateTime minus the parameter.
    public func minusHours(_ hours: Double) -> DateTime {
        let total = timeIntervalSince1970 - hours * 60 * 60
        return DateTime(timeIntervalSince1970: total, timeZone: timeZone)
    }
    
    /// Returns a new DateTime by subtracting the given days from this DateTime.
    /// - Parameter seconds: Days to subtract.
    /// - Returns: A new DateTime which is this DateTime minus the parameter.
    public func minusDays(_ days: Double) -> DateTime {
        let total = timeIntervalSince1970 - days * 60 * 60 * 24
        return DateTime(timeIntervalSince1970: total, timeZone: timeZone)
    }
    
    /// Calculates the day of the year (1st February is the 32nd day)
    /// - Throws: If the day of the year could not be calculated.
    /// - Returns: The day of the year.
    public func getDayOfYear() throws -> Int {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date)
        
        guard let dayOfYear = dayOfYear else {
            throw SunCalcError.dateManipulationError("Could not determine day of year.")
        }
        
        return dayOfYear
    }
    
    /// Returns the year of this DateTime.
    /// - Throws: If the year could not be extracted.
    /// - Returns: The year.
    public func getYear() throws -> Int {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let components = calendar.dateComponents([.year], from: date)
        
        guard let year = components.year else {
            throw SunCalcError.dateManipulationError("Could not determine year from DateTime: \(self.description)")
        }
        
        return year
    }
    
    /// Converts this DateTime to an equivalent DateTime in the local timezone.
    ///
    /// The local timezone is the one in which the user is currently.
    /// - Returns: The local DateTime.
    public func toLocalDate() -> DateTime {
        let localTimeZone = Calendar.current.timeZone
        let timeZoneDifference = localTimeZone.secondsFromGMT() - timeZone.secondsFromGMT()
        
        let alteredTimeIntervalSince1970 = timeIntervalSince1970 + Double(timeZoneDifference)
        
        return DateTime(timeIntervalSince1970: alteredTimeIntervalSince1970, timeZone: localTimeZone)
    }
}
