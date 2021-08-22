//
//  QuadraticInterpolation.swift
//  QuadraticInterpolation
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

/// Calculates the roots and extremum of a quadratic equation.
class QuadraticInterpolation {
    
    /// X at extremum.
    ///
    /// Can be outside [-1;1]
    let xe: Double
    
    /// Y at extremum.
    let ye: Double
    
    /// The number of roots found in [-1; 1]
    let numberOfRoots: Int
    
    /// True if the extremum is a maximum, otherwise it is a minimum.
    let isMaximum: Bool
    
    /// X of the first root that was found.
    var root1: Double {
        return _root1 < -1.0 ? _root2 : _root1
    }
    private let _root1: Double
    
    /// X of the second root that was found.
    var root2: Double {
        return _root2
    }
    private let _root2: Double
    
    init(yMinus: Double, y0: Double, yPlus: Double) {
        let a = 0.5 * (yPlus + yMinus) - y0
        let b = 0.5 * (yPlus - yMinus)
        let c = y0
        
        xe = -b / (2.0 * a)
        ye = (a * xe + b) * xe + c
        isMaximum = a < 0.0
        let dis = b * b - 4.0 * a * c
        
        var rootCount = 0
        
        if dis >= 0.0 {
            let dx = 0.5 * sqrt(dis) / abs(a)
            _root1 = xe - dx
            _root2 = xe + dx
            
            if abs(_root1) <= 1.0 {
                rootCount += 1
            }
            
            if abs(_root2) <= 1.0 {
                rootCount += 1
            }
        } else {
            _root1 = Double.nan
            _root2 = Double.nan
        }
        
        numberOfRoots = rootCount
    }
}
