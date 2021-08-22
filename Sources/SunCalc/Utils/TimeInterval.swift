//
//  TimeInterval.swift
//  TimeInterval
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

/// Extensions for TimeInterval to help construct relevant TimeIntervals for Sun/Moon calculations.
public extension TimeInterval {
    
    /// Returns a time interval of the number of days.
    /// - Parameter d: Number of days in interval.
    /// - Returns: The TimeInterval representing this duration.
    static func ofDays(_ d: Int) -> TimeInterval {
        let oneDay = 60 * 60 * 24
        let timeInterval: TimeInterval = Double(oneDay * d)
        return timeInterval
    }
    
    /// Returns a time interval of the number of hours.
    /// - Parameter h: Number of hours in interval.
    /// - Returns: The TimeInterval representing this duration.
    static func ofHours(_ h: Int) -> TimeInterval {
        let oneHour = 60 * 60
        let timeInterval: TimeInterval = Double(oneHour * h)
        return timeInterval
    }
    
    /// Returns a time interval of the difference between two points in time.
    /// - Parameters:
    ///   - t1: First point in time.
    ///   - t2: Second point in time.
    /// - Returns: The time between the two points in time, in seconds.
    static func between(_ t1: DateTime, _ t2: DateTime) -> Double {
        return t2.timeIntervalSince1970 - t1.timeIntervalSince1970
    }
    
    /// Returns a time interval of the difference between two TimeIntervals.
    /// - Parameters:
    ///   - t1: First TimeInterval.
    ///   - t2: Second TimeInterval.
    /// - Returns: The time between between the two TimeIntervals, in seconds.
    static func between(_ t1: TimeInterval, _ t2: TimeInterval) -> Double {
        return t2 - t1
    }
}
