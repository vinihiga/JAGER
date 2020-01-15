//
//  Shaders.metal
//  Game
//
//  Created by Vinicius Hiroshi Higa on 10/01/20.
//  Copyright © 2020 Vini Games. All rights reserved.
//

#include <metal_stdlib>
#include "ShaderDefinitions.h"

using namespace metal;


vertex float4 basic_vertex(const device VertexIn* vertices [[ buffer(0) ]],
                           unsigned int vid [[ vertex_id ]]) {
    return vertices[vid].position;
}

fragment half4 basic_fragment(constant FragmentUniforms &uniforms [[ buffer(0) ]]) {
    
    return half4(1.0 * uniforms.brightness, 1.0 * uniforms.brightness, 1.0 * uniforms.brightness, 1.0);
}
