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
    
    init(controller: GameController, size: CGSize, position: CGPoint) {
        super.init(controller: controller, size: size, position: position, color: SIMD4<Float>(1.0, 1.0, 1.0, 1.0))

    }
    
    override func tick(deltaTime: TimeInterval) {
        
        if (self.position.x) < (-self.controller.view.frame.width - (self.sprite?.size.width)!) {
            self.destroy()
        }
        
        self.position.x -= CGFloat(deltaTime * 150.0)
    }
    
}
