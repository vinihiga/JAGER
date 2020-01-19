//
//  Entity.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 18/01/20.
//

import Foundation
import CoreGraphics

open class Entity {
    
    public var position: CGPoint
    public var rigidBody: RigidBody?
    public var sprite: Sprite!
    public var controller: GameController!
    
    private(set) var isSetToDestroy: Bool!
    
    public init(controller: GameController, size: CGSize, position: CGPoint, color: SIMD4<Float>) {
        
        self.position = position
        self.controller = controller
        self.sprite = Sprite(controller: controller, entity: self, size: size, color: color)
        
        self.isSetToDestroy = false

    }
    
    open func tick(deltaTime: TimeInterval) {
        
    }
    
    public func destroy() {
        self.isSetToDestroy = true
    }

    
}
