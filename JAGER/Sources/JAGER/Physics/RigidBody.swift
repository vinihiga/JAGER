//
//  RigidBody.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 18/01/20.
//

import Foundation
import CoreGraphics

public class RigidBody {
    
    open var isEnabled: Bool!
    open var isGravityOn: Bool!
    open var isOnFloor: Bool!
    open var mass: CGFloat!
    
    private var entity: Entity! // TODO: Change to support generic types
    private var currentFallingSpeed: CGFloat = 0.0
    
    
    
    /// Default initializer for creating a Rigid Body on a selected Entity.
    /// - Parameter entity: Entity to be handled by the Rigid Body subsystem
    public init(entity: Entity) {
        
        self.entity = entity
        
        self.isEnabled = true
        self.isGravityOn = true
        self.isOnFloor = false
        self.mass = 1.0
        
    }
    
    

    /// Creates a falling mechanics on the current selected entity.
    /// - Parameter force: Desired amount of force
    public func fall(force: CGFloat) {
        if self.isEnabled && self.isGravityOn {
            self.currentFallingSpeed += force * Physics.DYNAMICS_DESIRED_FRAMES_PER_SECOND
            self.entity.position.y -= self.currentFallingSpeed
        }
    }
    
    
    
    /// Creates a jump mechanics on the current selected entity.
    /// - Parameter force: Desired amount of force at the instant that was called (a.k.a impulse)
    public func jump(force: CGFloat) {
        if self.isEnabled && self.isGravityOn {
            self.currentFallingSpeed = -force * Physics.DYNAMICS_DESIRED_FRAMES_PER_SECOND
        }
    }
    
    
    
    /// Resets the dynamics state to the initial state, where all values are equal to zero.
    public func reset() {
        self.currentFallingSpeed = 0.0
    }
    
}
