//
//  Material.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 11/01/20.
//

import Foundation
import Metal
import MetalKit

open class Character: Entity {
    
    override public init(controller: GameController, size: CGSize, position: CGPoint, color: SIMD4<Float>) {
        super.init(controller: controller, size: size, position: position, color: color)
        
        self.rigidBody = RigidBody(entity: self)
        
    }
    
}
