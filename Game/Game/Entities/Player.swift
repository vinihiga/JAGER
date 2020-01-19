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
    
    override func tick(deltaTime: TimeInterval) {
        
        self.sprite?.color = SIMD4<Float>(Float(0.5),
                                            Float(0.5 + 0.5 * sin(Date().timeIntervalSince1970)),
                                            Float(0.5 + 0.5 * cos(Date().timeIntervalSince1970)),
                                            Float(1.0))
    }
    
}
