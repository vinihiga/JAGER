//
//  Collider.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 19/01/20.
//

import Foundation

public class Collider {
    
    public var isEnabled: Bool!

    private var entity: Entity! // Entity that has collider attached
    
    
    
    /// ATTENTION! This Class requires a Sprite's instance on the Entity to work!
    /// Default initializer for creating a Collider on a selected Entity.
    /// - Parameter entity: Entity to be handled by the Collider subsystem
    public init(entity: Entity) {
        
        if entity.sprite == nil {
            fatalError("Error! Entity object doesn't have a Sprite attached into it!")
        }
        
        self.entity = entity
        self.isEnabled = true
    
    }
    
    
    
    /// Detects if a certain entity collides with the collider attached to another one.
    /// - Parameter target: Entity to be collided with the Collider's Entity
    public func intercepts(_ target: Entity) -> Bool {
        
        // TODO: Change the collision algorithm to support rotated boxes
        
        if target.collider != nil && self.isEnabled != false && target.sprite != nil {
        
            if (abs(self.entity.position.x - target.position.x) * 2 <= (self.entity.sprite!.size.width + target.sprite!.size.width)) &&
                (abs(self.entity.position.y - target.position.y) * 2 <= (self.entity.sprite!.size.height + target.sprite!.size.height)) {
                return true
            }
            
        }
    
            
        return false
    }
    
}
