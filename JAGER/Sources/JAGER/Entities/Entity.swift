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
    
    // Default attributes
    public var position: CGPoint
    public var rigidBody: RigidBody?
    public var collider: Collider?
    public var sprite: Sprite?
    public var controller: GameController!
    
    // States related attributes
    private(set) var isSetToDestroy: Bool!
    
    
    /// Default initializer that creates a square with a color and size.
    /// - Parameters:
    ///   - controller: The main game controller
    ///   - size: The size of the sprite
    ///   - position: The position in the world
    ///   - color: The color of the sprite in RGB and values between 0 and 1
    public init(controller: GameController, size: CGSize, position: CGPoint, color: SIMD3<Float>) {
        
        self.position = position
        self.controller = controller
        self.sprite = Sprite(controller: controller, entity: self, size: size, color: color)
        
        self.isSetToDestroy = false

    }
    
    
    
    /// Optional initializer that creates an entity with sprite, position and size.
    /// - Parameters:
    ///   - controller: The main game controller
    ///   - size: The size of the sprite
    ///   - position: The position in the world
    ///   - color: The color of the sprite in RGB and values between 0 and 1
    ///   - customShaders: The shaders names to be loaded
    ///   - texture: The image name to be loaded
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
    
    
    
    
    /// Optional initializer tha creates an invisible entity and without sprite.
    /// - Parameters:
    ///   - controller: The main game controller
    ///   - position: The position in the  world
    public init(controller: GameController, position: CGPoint) {
        
        self.position = position
        self.controller = controller
        
        self.isSetToDestroy = false
        
    }
    
    
    
    /// Detects if a certain entity collides with the collider attached to another one.
    /// - Parameter target: The another Entity that has collided with this one
    open func onCollision(with target: Entity) {
        
        if self.collider == nil {
            fatalError("Error! Collider's instance on self not found!")
        }
        
        // Do something here...
        
    }
    
    
    
    /// Updates any informations as desired.
    /// - Parameter deltaTime: The time between previous and the current frame
    open func tick(deltaTime: TimeInterval) {
        // Do something here...
    }
    
    
    
    /// Sets the flag for the engine destroy this Entity in the next frame.
    public func destroy() {
        self.isSetToDestroy = true
    }

    
}
