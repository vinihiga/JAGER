//
//  Entity.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 18/01/20.
//

import Foundation
import CoreGraphics
import MetalKit

open class Entity {
    
    public var position: CGPoint
    public var rigidBody: RigidBody?
    public var collider: Collider?
    public var sprite: Sprite?
    public var controller: GameController!
    
    private(set) var isSetToDestroy: Bool!
    
    public init(controller: GameController, size: CGSize, position: CGPoint, color: SIMD3<Float>) {
        
        self.position = position
        self.controller = controller
        self.sprite = Sprite(controller: controller, entity: self, size: size, color: color)
        
        self.isSetToDestroy = false

    }
    
    public init(controller: GameController, size: CGSize, position: CGPoint, color: SIMD3<Float>, customShaders: Shaders, texture: String) {
        
        self.position = position
        self.controller = controller
        self.sprite = Sprite(controller: controller,
                             entity: self,
                             size: size,
                             color: color,
                             customShaders: customShaders,
                             texture: texture)
        
        
        self.isSetToDestroy = false

    }
    
    public init(controller: GameController, position: CGPoint) {
        
        self.position = position
        self.controller = controller
        
        self.isSetToDestroy = false
        
    }
    
    open func onCollision(with target: Entity) {
        
        if self.collider == nil {
            fatalError("Error! Collider's instance on self not found!")
        }
        
        // Do something here...
        
    }
    
    open func tick(deltaTime: TimeInterval) {
        // Do something here...
    }
    
    public func destroy() {
        self.isSetToDestroy = true
    }

    
}
