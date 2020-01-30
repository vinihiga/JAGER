//
//  Uniforms.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 21/01/20.
//

import Foundation

struct Vertex {
    var position: SIMD4<Float>
    var texCoords: SIMD2<Float>
}

struct Fragment {
    var brightness: Float
    var color: SIMD4<Float>
    var eulerAngle: Float
}
