//
//  SunCalcError.swift
//  SunCalcError
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

/// An enumeration of the errors that might occur internally during calculation of various computations.
public enum SunCalcError: Error {
    case illegalArgumentError(_ msg: String)
    case dateManipulationError(_ msg: String)
    case arithmeticError(_ msg: String)
    case nilValueInCollection(_ msg: String)
    case unexpectedNilValue(_ msg: String)
}
