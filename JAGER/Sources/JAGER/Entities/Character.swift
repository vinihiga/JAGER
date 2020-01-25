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
    
    public init(controller: GameController, size: CGSize, position: CGPoint, color: SIMD3<Float>, texture: String) {
        super.init(controller: controller,
                   size: size,
                   position: position,
                   color: color,
                   customShaders: Shaders(vertexName: "sprite_vertex", fragmentName: "sprite_fragment"),
                   texture: texture)
        
        self.rigidBody = RigidBody(entity: self)
        self.collider = Collider(entity: self)
        
    }
    
}
