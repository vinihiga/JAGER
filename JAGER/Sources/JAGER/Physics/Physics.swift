//
//  Physics.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 18/01/20.
//

import Foundation
import CoreGraphics

open class Physics {
    
    public static var DYNAMICS_DESIRED_FRAMES_PER_SECOND: CGFloat = 1.0/60.0
    public static let EARTH_GRAVITY_ACCEL = CGFloat(9.807)
    
    
    
    /// Calculates force by giving the mass and the acceleration.
    /// - Parameters:
    ///   - mass: The mass of some body
    ///   - acceleration: The acceleration being applied in some body
    public static func addForce(mass: CGFloat, acceleration: CGFloat) -> CGFloat {
        return mass * acceleration;
    }
    
}
