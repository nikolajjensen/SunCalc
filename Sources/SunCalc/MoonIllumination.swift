//
//  MoonIllumination.swift
//  MoonIllumination
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

/// Calculates the illumination of the Moon.
public struct MoonIllumination: CustomStringConvertible {
    
    /// Illuminated fraction.
    ///
    /// 0.0 indicates new moon, 1.0 indicates full moon.
    public let fraction: Double
    
    /// Moon phase.
    ///
    /// Starts at -180.0 (new moon, waxing), passes 0.0 (full moon) and moves towards 180.0 (waning, new moon).
    /// Note that for historical reasons, the range of this phase is different to the moon phase angle used in MoonPhase.
    public let phase: Double
    
    /// The angle of the Moon illumination relative to Earth.
    ///
    /// The Moon is waxing if the angle is negative, and waning if positive.
    ///
    /// By Subtracting 'MoonPosition.parallacticAngle' from this measure, one can get the zenith angle of the Moon's
    /// bright limb (anticlockwise). The zenith angle can be used to draw the Moon shape fron the observers perspective
    /// (e.g. the moon lying on its back).
    public let angle: Double
    
    /// The closest MoonPhase structure that is matching the moon's angle.
    public var closestPhase: Phase {
        return Phase.toPhase(phase + 180.0)
    }
    
    /// Description of the MoonIllumination structure.
    public var description: String {
        return "MoonIllumination[fraction=\(fraction), phase=\(phase)°, angle=\(angle)°]"
    }
    
    init(fraction: Double, phase: Double, angle: Double) {
        self.fraction = fraction
        self.phase = phase
        self.angle = angle
    }
    
    /// Starts the computation of MoonIllumination.
    /// - Returns: A MoonIlluminationBuilder which we can set parameters for by calling its functions.
    public static func compute() -> MoonIlluminationBuilder {
        return MoonIlluminationBuilder()
    }
    
    /// Builder for MoonIllumination
    ///
    /// Performs the computations based on the parameters, and creates a MoonIllumination structure that holds the result.
    public class MoonIlluminationBuilder: BaseBuilder<MoonIlluminationBuilder>, Builder {
        public typealias T = MoonIllumination
        
        /// Computes the MoonIllumination structure based on parameters set.
        /// - Throws: If the MoonIllumination could not be calculated.
        /// - Returns: MoonIllumination structure.
        public func execute() throws -> MoonIllumination {
            let t = julianDate
            
            var s = try Sun.position(t)
            var m = try Moon.position(t)
            let phi: Double = Double.pi - acos(m.dot(s) / (m.getR() * s.getR()))
            var sunMoon = m.cross(s)
            
            return MoonIllumination(
                fraction: (1 + cos(phi)) / 2,
                phase: ExtendedMath.toDegrees(phi * sunMoon.getTheta().signum()),
                angle: ExtendedMath.toDegrees(sunMoon.getTheta()))
        }
    }
}
