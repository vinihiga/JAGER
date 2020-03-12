//
//  Physics.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 18/01/20.
//

import Foundation
import CoreGraphics

public class Physics {
    
    public static var DYNAMICS_DESIRED_FRAMES_PER_SECOND: CGFloat = 1.0/60.0
    public static let EARTH_GRAVITY_ACCEL = CGFloat(9.807)
    
    
    /// Handles the Physics on the Entities.
    /// NOTE: This is called by default before every subsystem (e.g. update entities)!
    public static func calculateDynamics(entities: [Entity]) {
        
        // Iterating for each entity to execute it's dynamics...
        for entity in entities {

            // Verifying if some rigid body is interacting with the gravity
            if entity.rigidBody != nil {
                if entity.rigidBody!.isEnabled {
                    entity.rigidBody!.fall(force: Physics.addForce(mass: 1.0, acceleration: Physics.EARTH_GRAVITY_ACCEL))
                }
            }

            // Verifying if some collider is intercepting another one
            if entity.collider != nil {
                if entity.collider!.isEnabled {

                    for target in entities {

                        if target !== entity {
                            let isCollided = entity.collider!.intercepts(target)

                            if isCollided {
                                entity.onCollision(with: target)
                            }
                        }

                    }

                }
            }
        }
        

    
    }
    
    
    
    /// Calculates force by giving the mass and the acceleration.
    /// - Parameters:
    ///   - mass: The mass of some body
    ///   - acceleration: The acceleration being applied in some body
    public static func addForce(mass: CGFloat, acceleration: CGFloat) -> CGFloat {
        return mass * acceleration;
    }
    
}
