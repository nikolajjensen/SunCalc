//
//  Matrix.swift
//  Matrix
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

/// A three dimensional Matrix.
struct Matrix: Equatable, CustomStringConvertible {
    
    /// Components of the Matrix.
    private var mx: [Double?]
    
    /// Description of the Matrix structure.
    public var description: String {
        return mx.description
    }
    
    init() {
        mx = [Double?](repeating: nil, count: 9)
    }
    
    init(_ values: Double...) throws {
        guard values.count == 9 else {
            throw SunCalcError.illegalArgumentError("Requires 9 values")
        }
        
        mx = values
    }
    
    /// Creates an identity Matrix.
    /// - Returns: Identity Matrix.
    static func identity() throws -> Matrix {
        return try Matrix(
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0
        )
    }
    
    /// Creates a Matrix that rotates a vector by the given angle at the X axis.
    /// - Parameter angle: Angle, in radians.
    /// - Returns: Rotation Matrix.
    static func rotateX(_ angle: Double) throws -> Matrix {
        let s: Double = sin(angle)
        let c: Double = cos(angle)

        return try Matrix(
            1.0, 0.0, 0.0,
            0.0, c, s,
            0.0, -s, c
        )
    }
    
    /// Creates a Matrix that rotates a vector by the given angle at the Y axis.
    /// - Parameter angle: Angle, in radians.
    /// - Returns: Rotation Matrix.
    static func rotateY(_ angle: Double) throws -> Matrix {
        let s: Double = sin(angle)
        let c: Double = cos(angle)
        
        return try Matrix(
            c, 0.0, -s,
            0.0, 1.0, 0.0,
            s, 0.0, c
        )
    }
    
    /// Creates a Matrix that rotates a vector by the given angle at the Z axis.
    /// - Parameter angle: Angle, in radians.
    /// - Returns: Rotation Matrix.
    static func rotateZ(_ angle: Double) throws -> Matrix {
        let s: Double = sin(angle)
        let c: Double = cos(angle)
        
        return try Matrix(
            c, s, 0.0,
            -s, c, 0.0,
            0.0, 0.0, 1.0
        )
    }
    
    /// Transposes this Matrix.
    /// - Returns: Matrix that is a transposition of this Matrix.
    func transpose() throws -> Matrix {
        var result = Matrix()
        
        for i in 0..<3 {
            for j in 0..<3 {
                try result.set(i, j, get(j, i))
            }
        }
        
        return result
    }
    
    /// Negates this Matrix.
    /// - Returns: Matrix that is a negation of this Matrix.
    func negate() -> Matrix {
        var result = Matrix()
        
        for i in 0..<9 {
            guard let mxi = mx[i] else {
                continue
            }
            
            result.mx[i] = -mxi
        }
        
        return result
    }
    
    /// Adds a Matrix to this Matrix.
    /// - Parameter right: Matrix to add.
    /// - Returns: Matrix that is the sum of both matrices.
    func add(_ right: Matrix) -> Matrix {
        var result = Matrix()
        
        for i in 0..<9 {
            guard let mxi = mx[i], let rmxi = right.mx[i] else {
                continue
            }
            
            result.mx[i] = mxi + rmxi
        }
        
        return result
    }
    
    /// Subtracts a Matrix from this Matrix.
    /// - Parameter right: Matrix to subtract.
    /// - Returns: Matrix that is the difference of both matrices.
    func subtract(_ right: Matrix) -> Matrix {
        var result = Matrix()
        
        for i in 0..<9 {
            guard let mxi = mx[i], let rmxi = right.mx[i] else {
                continue
            }
            
            result.mx[i] = mxi - rmxi
        }
        
        return result
    }
    
    /// Multiplies two matrices.
    /// - Parameter right: Matrix to multiply with.
    /// - Throws: If some values are missing.
    /// - Returns: Matrix that is the product of both matrices.
    func multiply(_ right: Matrix) throws -> Matrix {
        var result = Matrix()
        
        for i in 0..<3 {
            for j in 0..<3 {
                var scalp: Double = 0.0
                
                for k in 0..<3 {
                    scalp += try get(i, k) * right.get(k, j)
                }
                
                try result.set(i, j, scalp)
            }
        }
        
        return result
    }
    
    /// Multiplies a Matrix by a scalar.
    /// - Parameter scalar: Scalar to multiply with.
    /// - Returns: Matrix that is the scalar product.
    func multiply(_ scalar: Double) -> Matrix {
        var result = Matrix()
        
        for i in 0..<9 {
            guard let mxi = mx[i] else {
                continue
            }
            
            result.mx[i] = mxi * scalar
        }
        
        return result
    }
    
    /// Multiplies a Matrix by a Vector.
    /// - Parameter vector: Vector to multiply with.
    /// - Throws: If some values are missing, or if the result has unexpected dimensions.
    /// - Returns: Matrix that is the product of this Matrix and the given Vector.
    func multiply(_ right: Vector) throws -> Vector {
        let vec: [Double] = [right.x, right.y, right.z]
        var result = [Double?](repeating: nil, count: 3)
        
        for i in 0..<3 {
            var scalp: Double = 0
            
            for j in 0..<3 {
                scalp += try get(i, j) * vec[j]
            }
            
            result[i] = scalp
        }
        
        let unwrapped = result.compactMap({ $0 })
        
        guard unwrapped.count == 3 else {
            throw SunCalcError.nilValueInCollection("Vector Multiplication failed; result does not contain 3 non-nil values.")
        }
        
        return try Vector(unwrapped)
    }
    
    /// Gets a value from the Matrix.
    /// - Parameters:
    ///   - r: Row number (0, 1, or 2).
    ///   - c: Column number (0, 1, or 2).
    /// - Throws: If the row and column combination is out of range, OR if the value in the Matrix is 'nil'.
    /// - Returns: The value at the position in the Matrix.
    func get(_ r: Int, _ c: Int) throws -> Double {
        if (r < 0 || r > 2 || c < 0 || c > 2) {
            print("Row/column out of range: \(r):\(c)")
            throw SunCalcError.illegalArgumentError("Row/column out of range: \(r):\(c)")
        }
        
        guard let retrieved = mx[r * 3 + c] else {
            throw SunCalcError.nilValueInCollection("The retrieved value is nil.")
        }
        
        return retrieved
    }
    
    /// Changes a value in the Matrix.
    /// - Parameters:
    ///   - r: Row number (0, 1, or 2).
    ///   - c: Column number (0, 1, or 2).
    /// - Throws: If the row and column combination is out of range.
    private mutating func set(_ r: Int, _ c: Int, _ v: Double) throws {
        if (r < 0 || r > 2 || c < 0 || c > 2) {
            throw SunCalcError.illegalArgumentError("Row/column out of range: \(r):\(c)")
        }
        
        mx[r * 3 + c] = v
    }
    
    /// Checks if two Matrix structures are equal (have equal elements).
    static func == (lhs: Matrix, rhs: Matrix) -> Bool {
        return lhs.mx == rhs.mx
    }
}
