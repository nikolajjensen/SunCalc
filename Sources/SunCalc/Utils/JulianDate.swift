//
//  JulianDate.swift
//  JulianDate
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

/// Structure for JulianDate components.
public struct JulianDate: CustomStringConvertible {
    
    /// The DateTime corresponding to this JulianDate.
    public let dateTime: DateTime
    
    /// The Modified Julian Date.
    public let mjd: Double
    
    /// The Julian Century, based on j2000 epoch, UTC.
    public var julianCentury: Double {
        return (mjd - 51544.5) / 36525.0
    }
    
    /// Description of the JulianDate structure.
    public var description: String {
        return "\(mjd)d \((mjd * 24).truncatingRemainder(dividingBy: 24))h \((mjd * 24 * 60).truncatingRemainder(dividingBy: 60))m \((mjd * 24 * 60 * 60).truncatingRemainder(dividingBy: 60))s"
    }
    
    public init(_ time: DateTime) {
        self.dateTime = time
        self.mjd = dateTime.timeIntervalSince1970 / 86400.0 + 40587.0
    }
    
    /// Returns a JulianDate of the current date and the given hour.
    /// - Parameter hour: Hour of this date. This is a floating point value. Fractions are used for minutes and seconds.
    /// - Returns: JulianDate of the current date and the given hour.
    public func atHour(_ hour: Double) -> JulianDate {
        return JulianDate(dateTime.plusHours(hour))
    }
    
    /// Returns a JulianDate of the given modified Julian date.
    /// - Parameter mjd: Modified Julian date.
    /// - Returns: Julian Date of the modified Julian date given.
    public func atModifiedJulianDate(_ mjd: Double) -> JulianDate {
        let mjdi: TimeInterval = ((mjd - 40587.0) * 86400.0).rounded()
        return JulianDate(DateTime(timeIntervalSince1970: mjdi, timeZone: dateTime.timeZone))
    }
    
    /// Returns a Julian date of the given Julian century.
    /// - Returns: JulianDate of the given Julian century.
    public func atJulianCentury(_ jc: Double) -> JulianDate {
        return atModifiedJulianDate(jc * 36525.0 + 51544.5)
    }
    
    /// Returns the Greenwich Mean Sidereal Time of this Julian Date.
    /// - Returns: GMST.
    public func getGreenwichMeanSiderealTime() -> Double {
        let secs: Double = 86400.0
        
        let mjd0 = floor(mjd)
        let ut = (mjd - mjd0) * secs
        let t0 = (mjd0 - 51544.5) / 36525.0
        let t = (mjd - 51544.5) / 36525.0
        
        let gmst = 24110.54841 + 8640184.812866 * t0 + 1.0027379093 * ut + (0.093104 - 6.2e-6 * t) * t * t
        
        return (ExtendedMath.pi2 / secs) * gmst.truncatingRemainder(dividingBy: secs)
    }
    
    /// Returns the Earth's true anomaly of the current date.
    ///
    /// A simple approximation is used here.
    /// - Throws: If day of year could not be extracted from the DateTime.
    /// - Returns: True anomaly, in radians.
    public func getTrueAnomaly() throws -> Double {
        return ExtendedMath.pi2 * ExtendedMath.frac((Double(try dateTime.getDayOfYear()) - 5.0) / 365.256363)
    }
}
