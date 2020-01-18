//
//  Material.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 11/01/20.
//

import Foundation
import Metal
import MetalKit

struct FragmentUniforms {
    var brightness: Float
    var color: SIMD4<Float>
}

class Sprite {
    
    private(set) var texture: MTLTexture!
    
    init(texture: MTLTexture) {
        self.texture = texture
    }
    
}
