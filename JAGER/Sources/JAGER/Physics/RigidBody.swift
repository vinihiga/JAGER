//
//  RigidBody.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 18/01/20.
//

import Foundation
import CoreGraphics

public class RigidBody {
    
    public var isEnabled: Bool!
    public var isGravityOn: Bool!
    public var isOnFloor: Bool!
    public var mass: CGFloat!
    
    private var entity: Entity! // TODO: Change to support generic types
    private var currentFallingSpeed: CGFloat = 0.0
    
    
    
    /// Default initializer for creating a Rigid Body on a selected Entity.
    /// - Parameter entity: Entity to be handled by the Rigid Body subsystem
    public init(entity: Entity) {
        
        self.entity = entity
        
        self.isEnabled = true
        self.isOnFloor = false
        self.mass = 1.0
    }
    
    
    // TOOD: Checar diferença entre força e impulso para esse caso específico (plataforma 2D)
    
    /// Creates a falling mechanics on the current selected entity.
    /// - Parameter force: Desired amount of force
    public func fall(force: CGFloat) {
        if self.isEnabled && self.isGravityOn {
            self.currentFallingSpeed += force * Physics.DYNAMICS_DESIRED_FRAMES_PER_SECOND
            self.entity.position.y -= self.currentFallingSpeed
        }
    }
    
    
    
    /// Creates a jump mechanics on the current selected entity.
    /// - Parameter force: Desired amount of force
    public func jump(force: CGFloat) {
        if self.isEnabled && self.isGravityOn {
            self.currentFallingSpeed = -force * Physics.DYNAMICS_DESIRED_FRAMES_PER_SECOND
            //self.entity.position.y += self.currentFallingSpeed
        }
    }
    
    
    
    
    /// Resets the dynamics state to the initial state, where all values are equal to zero.
    public func reset() {
        self.currentFallingSpeed = 0.0
    }
    
}
