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


vertex float4 basic_vertex(const device packed_float3* vertex_array [[ buffer(0) ]],
                           unsigned int vid [[ vertex_id ]]) {
    return float4(vertex_array[vid], 1.0);
}

fragment half4 basic_fragment(constant FragmentUniforms &uniforms [[ buffer(0) ]]) {

    return half4(1.0 * uniforms.brightness, 1.0  * uniforms.brightness, 1.0  * uniforms.brightness, 1.0);
}
