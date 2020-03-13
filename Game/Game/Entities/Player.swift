//
//  Player.swift
//  Game
//
//  Created by Vinicius Hiroshi Higa on 19/01/20.
//  Copyright © 2020 Vini Games. All rights reserved.
//

import Foundation
import CoreGraphics
import MetalKit
import JAGER

class Player: Character {
    
    private var isMovingToRight = false
    
    init(controller: Game, size: CGSize, position: CGPoint) {
        super.init(
            controller: controller,
            name: "Player",
            size: size,
            position: position,
            color: SIMD3<Float>(repeating: 1.0),
            brightness: 1.0,
            texture: "SPR_Player")
        
        self.rigidBody?.isGravityOn = false
        self.sprite?.eulerAngle = CGFloat(180.0)
        
    }
    
    
    
    /// Handles the player's character behaviour per frame.
    /// - Parameter deltaTime: The time between previous and the current frame
    override func tick(deltaTime: TimeInterval) {
        super.tick(deltaTime: deltaTime)
    
        
        self.recalculateTheShadow()
        
        self.moveAndRepeat(deltaTime: deltaTime)
        
    }
    
    
    
    
    /// DEBUG: This is a debug function and should not be implemented on the MASTER version!
    /// TODO: Make the shadow be calculated automatic on the engine side!
    private func recalculateTheShadow() {
        
        do {
            let entities = try self.controller.getCurrentScene().entities
            
            for entity in entities {
                if entity.name == "Light Emitter" {
                    let distance = Algebra.distance(from: self.position, to: entity.position)
                    
                    self.sprite?.brightness = Float(abs((distance - 450.0) / 450.0))
                    
                    if distance > 450.0 {
                        self.sprite?.brightness = 0.0
                    }
                    
                }
            }
            
        }
        catch {}
        
    }
    
    
    
    private func moveAndRepeat(deltaTime: TimeInterval) {
        
        if !self.isMovingToRight {
            
            if self.position.x > -200 {
                self.position.x -= CGFloat(deltaTime * 60.0);
            }
            else {
                self.isMovingToRight = true
            }
            
        }
        else {
            
            if self.position.x < 100 {
                self.position.x += CGFloat(deltaTime * 60.0);
            }
            else {
                self.isMovingToRight = false
            }
            
            
        }
        
    }
    
    
    
}
