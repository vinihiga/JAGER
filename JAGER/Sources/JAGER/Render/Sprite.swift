//
//  Material.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 11/01/20.
//

import Foundation
import Metal
import MetalKit

struct Vertex {
    var position: SIMD4<Float>
    var texCoords: SIMD2<Float>
}

struct FragmentUniforms {
    var brightness: Float
}

class Sprite {
    
    private(set) var texture: MTLTexture!
    
    init(texture: MTLTexture) {
        self.texture = texture
    }
    
}
