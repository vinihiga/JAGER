//
//  Player.swift
//  Game
//
//  Created by Vinicius Hiroshi Higa on 19/01/20.
//  Copyright © 2020 Vini Games. All rights reserved.
//

import Foundation
import CoreGraphics
import JAGER

class Player: Character {
    
    override init(controller: GameController, size: CGSize, position: CGPoint, color: SIMD3<Float>) {
        super.init(controller: controller, size: size, position: position, color: color)

    }
    
    override func tick(deltaTime: TimeInterval) {
        
        self.sprite?.color = SIMD3<Float>(Float(0.5),
                                            Float(0.5 + 0.5 * sin(Date().timeIntervalSince1970)),
                                            Float(0.5 + 0.5 * cos(Date().timeIntervalSince1970)))
    }
    
}
