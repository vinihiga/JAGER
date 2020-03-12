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
    
    init(controller: Game, size: CGSize, position: CGPoint) {
        super.init(
            controller: controller,
            name: "Player",
            size: size,
            position: position,
            color: SIMD3<Float>(repeating: 1.0),
            texture: "SPR_Player")
        
    }
    
    override func tick(deltaTime: TimeInterval) {
        
        self.sprite?.color = SIMD3<Float>(Float(0.5),
                                            Float(0.5 + 0.5 * sin(Date().timeIntervalSince1970)),
                                            Float(0.5 + 0.5 * cos(Date().timeIntervalSince1970)))
        
        self.sprite?.eulerAngle = CGFloat(self.sprite!.eulerAngle) + CGFloat(45.0) * CGFloat(deltaTime)
        
    }
    
}
