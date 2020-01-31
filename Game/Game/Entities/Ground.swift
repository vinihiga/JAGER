//
//  Ground.swift
//  Game
//
//  Created by Vinicius Hiroshi Higa on 20/01/20.
//  Copyright © 2020 Vini Games. All rights reserved.
//

import Foundation
import CoreGraphics
import JAGER

class Ground: Entity {
    
    init(controller: GameController, size: CGSize, position: CGPoint) {
        super.init(controller: controller, size: size, position: position, color: SIMD3<Float>(1.0, 1.0, 1.0))

        self.collider = Collider(entity: self)
    }
    
    override func onCollision(with target: Entity) {
        
        if target is Player {
            self.controller.reset()
        }
        
    }
    
}
