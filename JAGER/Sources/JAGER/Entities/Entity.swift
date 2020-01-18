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
    
    private var gameController: GameController!
    
    public init(gameController: GameController, size: CGSize, position: CGPoint, color: SIMD4<Float>) {
        
        self.position = position
        self.gameController = gameController
        self.sprite = Sprite(gameController: gameController, entity: self, size: size, color: color)
        
        self.rigidBody = RigidBody(entity: self)
    }

    
}
