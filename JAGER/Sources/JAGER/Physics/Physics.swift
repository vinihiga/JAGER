//
//  Physics.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 18/01/20.
//

import Foundation
import CoreGraphics

open class Physics {
    
    public static let EARTH_GRAVITY_ACCEL = CGFloat(9.807)
    
    public static func addForce(mass: CGFloat, acceleration: CGFloat) -> CGFloat {
        return mass * acceleration;
    }
    
}