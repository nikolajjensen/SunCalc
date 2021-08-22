//
//  BaseBuilder.swift
//  BaseBuilder
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

/// A base implementation of common parameters that might be set, regardless of the calculation being made.
///
/// This BaseBuilder can be of a type of a structure that conforms to the Builder protocol.
public class BaseBuilder<B: Builder> {
    
    /// Latitude of the observer, in degrees.
    public var latitude: Double = 0.0
    
    /// Longitude of the observer, in degrees.
    public var longitude: Double = 0.0
    
    /// Height of the observer, in meters above sea level.
    ///
    /// Default: 0.0m. Negative values are silently changed to the acceptable minimum of 0m.
    public var height: Double = 0.0
    
    /// The DateTime to be used for calculations.
    ///
    /// Default is now (in the current time zone).
    public var dateTime: DateTime = DateTime.now()
    
    /// Longitude of the observer, in radians.
    public var longitudeRad: Double {
        return ExtendedMath.toRadians(longitude)
    }
    
    /// Latitude of the observer, in radians.
    public var latitudeRad: Double {
        return ExtendedMath.toRadians(latitude)
    }
    
    /// JulianDate corresponding to the DateTime.
    public var julianDate: JulianDate {
        return JulianDate(dateTime)
    }
    
    // Required for Generic Parameter copy implementation.
    required init() { }
}

/// Implement GenericParameters used by all Builders.
extension BaseBuilder: GenericParameter {
    
    /// Creates a copy of the current Builder.
    /// - Returns: The Builder.
    public func copy() -> B {
        let copy = type(of: self).init()
        copy.latitude = self.latitude
        copy.longitude = self.longitude
        copy.height = self.height
        copy.dateTime = self.dateTime
        return copy as! B
    }
}

/// Implement LocationParameters used by all Builders.
extension BaseBuilder: LocationParameter {
    
    /// Sets the latitude.
    /// - Parameter lat: The latitude to set, in degrees.
    /// - Throws: If the latitude is outside the acceptable range.
    /// - Returns: The Builder.
    public func latitude(_ lat: Double) throws -> B {
        if (lat < -90.0 || lat > 90.0) {
            throw SunCalcError.illegalArgumentError("Latitude out of range, -90 <= \(lat) <= 90")
        }
        self.latitude = lat
        return self as! B
    }
    
    /// Sets the longitude.
    /// - Parameter lng: The longitude to set, in degrees.
    /// - Throws: If the longitude is outside the acceptable range.
    /// - Returns: The Builder.
    public func longitude(_ lng: Double) throws -> B {
        if (lng < -180.0 || latitude > 180.0) {
            throw SunCalcError.illegalArgumentError("Longitude out of range, -180 <= \(lng) <= 180")
        }
        self.longitude = lng
        return self as! B
    }
    
    /// Sets the height.
    /// - Parameter h: The height to set, in meters above sea level.
    /// - Returns: The Builder.
    public func height(_ h: Double) -> B {
        self.height = max(h, 0.0)
        return self as! B
    }
    
    /// Sets the latitude, longitude, and height to the same as another Builder that also has these.
    /// - Parameter l: Another Builder that conforms to the protocol 'LocationParameter'.
    /// - Returns: The Builder.
    public func sameLocationAs<P>(_ l: P) -> B where P : LocationParameter {
        self.latitude = l.latitude
        self.longitude = l.longitude
        self.height = l.height
        return self as! B
    }
}

/// Implement TimeParameters used by all Builders.
extension BaseBuilder: TimeParameter {
    
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
    public func on(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) throws -> B {
        return on(try DateTime(year: year, month: month, day: day, hour: hour, minute: minute, second: second, timeZone: dateTime.timeZone))
    }
    
    /// Sets the time of calculation.
    /// - Parameter dateTime: The DateTime to use.
    /// - Returns: The Builder.
    public func on(_ dateTime: DateTime) -> B {
        self.dateTime = dateTime
        return self as! B
    }
    
    /// Sets the time of calculation to now (in the current timezone).
    /// - Returns: The Builder.
    public func now() -> B {
        return on(DateTime.now())
    }
    
    /// Sets the time of calculation to last midnight (in the current timezone), from the currently set DateTime.
    /// - Returns: The Builder.
    public func midnight() -> B {
        return on(DateTime.midnight())
    }
    
    /// Sets the time of calculation to the Builder's DateTime, plus a number of days.
    /// - Parameter days: Number of days to add.
    /// - Returns: The Builder.
    public func plusDays(_ days: Int) -> B {
        return plusDays(Double(days))
    }
    
    /// Sets the time of calculation to the Builder's DateTime, plus a number of days.
    /// - Parameter days: Number of days to add.
    /// - Returns: The Builder.
    public func plusDays(_ days: Double) -> B {
        return on(dateTime.plusDays(days))
    }
    
    /// Sets the timezone.
    ///
    /// Setting the timezone does not change the local time. For example, 6:50 GMT will be 6:50 CET after changing timezone to CET)
    /// - Parameter tz: Timezone to set.
    /// - Returns: The Builder.
    public func timezone(_ tz: TimeZone) -> B {
        let tzDifference = tz.secondsFromGMT(for: Date(timeIntervalSince1970: dateTime.timeIntervalSince1970)) - self.dateTime.timeZone.secondsFromGMT(for: Date(timeIntervalSince1970: dateTime.timeIntervalSince1970))
        self.dateTime.timeZone = tz
        self.dateTime.timeIntervalSince1970 = self.dateTime.timeIntervalSince1970 - Double(tzDifference)
        return self as! B
    }
    
    /// Sets the time to the same as another Builder that also has a DateTime.
    /// - Parameter l: Another Builder that conforms to the protocol 'TimeParameter'.
    /// - Returns: The Builder.
    public func sameTimeAs<P>(_ t: P) throws -> B where P : TimeParameter {
        self.dateTime = t.dateTime
        return self as! B
    }
}
