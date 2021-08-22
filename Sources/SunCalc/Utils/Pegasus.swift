//
//  Pegasus.swift
//  Pegasus
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

/// Finds the root of a function using the Pegasus method.
///
/// See more: https://en.wikipedia.org/wiki/False_position_method
class Pegasus {
    private static let maxIterations = 30
    
    /// Find the root of the given function within the boundaries.
    /// - Parameters:
    ///   - lower: Lower boundary.
    ///   - upper: Upper boundary.
    ///   - accuracy: Desired accuracy.
    ///   - f: Function to be used for calculation.
    /// - Throws: If the root could not be found in the given accuracy within 'maxIterations'.
    /// - Returns: The root that was found.
    static func calculate(lower: Double, upper: Double, accuracy: Double, f: (Double) throws -> (Double)) throws -> Double {
        var x1 = lower
        var x2 = upper
        
        var f1 = try f(x1)
        var f2 = try f(x2)
        
        if f1 * f2 >= 0.0 {
            throw SunCalcError.arithmeticError("No root within the given boundaries")
        }
        
        var i = maxIterations
        
        while i > 0 {
            let x3 = x2 - f2 / ((f2 - f1) / (x2 - x1))
            let f3 = try f(x3)
            
            if f3 * f2 <= 0.0 {
                x1 = x2
                f1 = f2
                x2 = x3
                f2 = f3
            } else {
                f1 = f1 * f2 / (f2 + f3)
                x2 = x3
                f2 = f3
            }
            
            if abs(x2 - x1) <= accuracy {
                return abs(f1) < abs(f2) ? x1 : x2
            }
            
            i -= 1
        }
        
        throw SunCalcError.arithmeticError("Maximum number of iterations exceeded.")
    }
}
