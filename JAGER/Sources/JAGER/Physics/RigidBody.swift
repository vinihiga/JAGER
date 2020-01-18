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
    
    init(entity: Entity) {
        
        self.entity = entity
        
        self.isEnabled = true
        self.isEnabled = true
        self.isOnFloor = false
        self.mass = 1.0
    }
    
    public func fall(force: CGFloat) {
        self.currentFallingSpeed += force * 1/60
        self.entity.position.y -= self.currentFallingSpeed
    }
    
    public func jump(force: CGFloat) {
        self.currentFallingSpeed = (self.mass * -600) * 1/60
        self.entity.position.y += self.currentFallingSpeed
    }
    
}
