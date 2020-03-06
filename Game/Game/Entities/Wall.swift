//
//  Wall.swift
//  Game
//
//  Created by Vinicius Hiroshi Higa on 18/01/20.
//  Copyright © 2020 Vini Games. All rights reserved.
//

import Foundation
import CoreGraphics
import JAGER

class Wall: Entity {
    
    private static let SPEED = 150.0
    
    init(controller: GameController, size: CGSize, position: CGPoint) {
        super.init(controller: controller, name: "Wall", size: size, position: position, color: SIMD3<Float>(1.0, 1.0, 1.0))

        self.collider = Collider(entity: self)
    }
    
    override func onCollision(with target: Entity) {
        
        if target is Player {
            do {
                try self.controller.getCurrentScene().reset()
            }
            catch {}
        }
        
    }
    
    override func tick(deltaTime: TimeInterval) {
        
        if (self.position.x) < (-self.controller.view.frame.width - (self.sprite?.size.width)!) {
            self.destroy()
        }
        
        self.position.x -= CGFloat(deltaTime * Wall.SPEED)
    }
    
}
