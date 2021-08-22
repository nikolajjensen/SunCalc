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

extension FloatingPoint {
    
    /// Signum for floating point numbers.
    /// Credit to Steve Canon: https://forums.swift.org/t/why-no-signum-on-floating-point-types/15659/2
    @inlinable
    func signum( ) -> Self {
        if self < 0 { return -1 }
        if self > 0 { return 1 }
        return 0
    }
}
