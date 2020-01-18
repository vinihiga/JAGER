//
//  Material.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 11/01/20.
//

import Foundation
import Metal
import MetalKit

public struct RigidBody {
    
    var isEnabled: Bool = true
    var isGravityOn: Bool = true
    var isOnFloor: Bool = false
    
    var currentFallingSpeed: CGFloat = 0.0
    
}

public class Player: Sprite {
    
    public var rigidBody: RigidBody!
    
    override init(gameController: GameController, size: CGSize, position: CGPoint, color: SIMD4<Float>) {
        super.init(gameController: gameController, size: size, position: position, color: color)
        
        self.rigidBody = RigidBody(isEnabled: true, isGravityOn: true, isOnFloor: false, currentFallingSpeed: 0)
    }

    
}
