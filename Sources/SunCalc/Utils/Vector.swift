//
//  Vector.swift
//  Vector
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

/// A three dimensional Vector.
struct Vector: Equatable, CustomStringConvertible {
    
    /// The cartesian x coordinate.
    let x: Double
    
    /// The cartesian x coordinate.
    let y: Double
    
    /// The cartesian x coordinate.
    let z: Double
    
    /// The polar representation of the Vector.
    private var polar: Polar!
    
    /// Description of the Vector structure.
    public var description: String {
        return "(x=\(x), y=\(y), z=\(z))"
    }
    
    /// Constructs a new Vector of the given cartesian coordinates.
    /// - Parameters:
    ///   - x: X coordinate.
    ///   - y: Y coordinate.
    ///   - x: Z coordinate.
    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.polar = Polar(self)
    }
    
    /// Attempts to construct a new Vector of the given cartesian coordinates.
    /// - Parameters:
    ///   - d: Array of coordinates, must have 3 elements.
    init(_ d: [Double]) throws {
        if d.count != 3 {
            throw SunCalcError.illegalArgumentError("Invalid vector length")
        }
        
        self.x = d[0]
        self.y = d[1]
        self.z = d[2]
        self.polar = Polar(self)
    }
    
    /// Creates a new Vector of the given polar coordinates, with a radial distance of 1.
    /// - Parameters:
    ///    - φ: Azimuthal angle.
    ///    - θ: Polar angle.
    /// - Returns: The created Vector.
    static func ofPolar(_ φ: Double, _ θ: Double) -> Vector {
        return ofPolar(φ, θ, 1.0)
    }
    
    /// Creates a new Vector of the given polar coordinates.
    /// - Parameters:
    ///    - φ: Azimuthal angle.
    ///    - θ: Polar angle.
    ///    - r: Radial distance.
    /// - Returns: The created Vector.
    static func ofPolar(_ φ: Double, _ θ: Double, _ r: Double) -> Vector {
        let cosθ = cos(θ)
        
        var result: Vector = Vector(
            r * cos(φ) * cosθ,
            r * sin(φ) * cosθ,
            r * sin(θ))
        
        result.polar.setPolar(φ, θ, r)
        return result
    }
    
    /// Returns the azimuthal angle angle (φ) in radians.
    mutating func getPhi() -> Double {
        return polar.getPhi()
    }
    
    /// Returns the polar angle (θ) in radians.
    mutating func getTheta() -> Double {
        return polar.getTheta()
    }
    
    /// Returns the radial distance (r).
    mutating func getR() -> Double {
        return polar.getR()
    }
    
    /// Returns a Vector that is the sum of this Vector and the given Vector.
    /// - Parameter vec: The Vector to add.
    /// - Returns: Resulting Vector.
    func add(_ vec: Vector) -> Vector {
        return Vector(
            x + vec.x,
            y + vec.y,
            z + vec.z)
    }
    
    /// Returns a Vector that is the difference of this Vector and the given Vector.
    /// - Parameter vec: The Vector to subtract.
    /// - Returns: Resulting Vector.
    func subtract(_ vec: Vector) -> Vector {
        return Vector(
            x - vec.x,
            y - vec.y,
            z - vec.z)
    }
    
    /// Returns a Vector that is the product of this Vector and the given Vector.
    /// - Parameter vec: The Vector to multiply.
    /// - Returns: Resulting Vector.
    func multiply(_ vec: Vector) -> Vector {
        return Vector(
            x * vec.x,
            y * vec.y,
            z * vec.z)
    }
    
    /// Returns a negtion of this Vector.
    /// - Returns: Resulting Vector.
    func negate() -> Vector {
        return Vector(
            -x,
            -y,
            -z)
    }
    
    /// Returns a Vector that is the cross product of this Vector and the given Vector.
    /// - Parameter vec: The Vector to multiply.
    /// - Returns: Resulting Vector.
    func cross(_ right: Vector) -> Vector {
        return Vector(
            y * right.z - z * right.y,
            z * right.x - x * right.z,
            x * right.y - y * right.x)
    }
    
    /// Returns the dot product of this Vector and the given Vector.
    /// - Parameter vec: The Vector to multiply.
    /// - Returns: Resulting dot product.
    func dot(_ right: Vector) -> Double {
        return x * right.x + y * right.y + z * right.z
    }
    
    /// Returns the norm of this Vector.
    /// - Returns: Norm of this vector.
    func norm() -> Double {
        return sqrt(dot(self))
    }
    
    /// Checks if two Vectors are equal (have equal elements).
    static func == (lhs: Vector, rhs: Vector) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    /// Helper class for lazily computing the polar coordinates in a Vector.
    private struct Polar {
        
        /// Azimuthal angle.
        private var φ: Double?
        
        /// Polar angle.
        private var θ: Double?
        
        /// Radial distance.
        private var r: Double?
        
        /// X coordinate of the accompanying Vector
        private let x: Double
        
        /// Y coordinate of the accompanying Vector
        private let y: Double
        
        /// Z coordinate of the accompanying Vector
        private let z: Double
        
        init(_ vector: Vector) {
            self.x = vector.x
            self.y = vector.y
            self.z = vector.z
        }
        
        /// Sets the polar coordinates.
        /// - Parameters:
        ///    - φ: Azimuthal angle.
        ///    - θ: Polar angle.
        ///    - r: Radial distance.
        mutating func setPolar(_ φ: Double, _ θ: Double, _ r: Double) {
            self.φ = φ
            self.θ = θ
            self.r = r
        }
        
        /// Returns the azimuthal angle (φ) in radians.
        mutating func getPhi() -> Double {
            guard let φUnwrapped = φ else {
                if ExtendedMath.isZero(x) && ExtendedMath.isZero(y) {
                    φ = 0.0
                } else {
                    φ = atan2(y, x)
                }
                
                if φ! < 0.0 {
                    φ! += ExtendedMath.pi2
                }
                
                return φ!
            }
            
            return φUnwrapped
        }
        
        /// Returns the polar angle (θ) in radians.
        mutating func getTheta() -> Double {
            guard let θUnwrapped = θ else {
                let pSqr = x * x + y * y
                
                if ExtendedMath.isZero(z) && ExtendedMath.isZero(pSqr) {
                    θ = 0.0
                } else {
                    θ = atan2(z, sqrt(pSqr))
                }
                
                return θ!
            }
            
            return θUnwrapped
        }
        
        /// Returns the radial distance.
        mutating func getR() -> Double {
            guard let rUnwrapped = r else {
                r = sqrt(x * x + y * y + z * z)
                
                return r!
            }
            
            return rUnwrapped
        }
    }
}
