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
                          unsigned int vid [[ vertex_id ]],
                          constant float2* viewportSizePtr [[ buffer(1) ]]) {
    
    float2 pixelSpacePosition = vertices[vid].position.xy;
    float2 viewportSize = float2(*viewportSizePtr);

    float4 pixelPositionIn4D = float4(pixelSpacePosition.x / viewportSize.x, pixelSpacePosition.y / viewportSize.y, 0, 1.0);

    return pixelPositionIn4D;
    
}

fragment half4 basic_fragment(constant FragmentUniforms &uniforms [[ buffer(0) ]]) {
    
    return half4(uniforms.color.r * uniforms.brightness, uniforms.color.g * uniforms.brightness, uniforms.color.b * uniforms.brightness, uniforms.color.a);
}

