//
//  SpriteShader.metal
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 23/01/20.
//

#include <metal_stdlib>
#include "ShaderDefinitions.h"

using namespace metal;


vertex VertexOut sprite_vertex(unsigned int vid [[ vertex_id ]],
                               const device VertexIn* vertexIn [[ buffer(0) ]],
                               constant float2* viewportSizePtr [[ buffer(1) ]]) {
    
    // Converting model position to world position...
    float2 pixelSpacePosition = vertexIn[vid].position.xy;
    float2 viewportSize = float2(*viewportSizePtr);

    float4 pixelPositionIn4D = float4(pixelSpacePosition.x / viewportSize.x, pixelSpacePosition.y / viewportSize.y, 0, 1.0);

    // Re-mapping the vertex with new world position and setting it's semantic to POSITION
    VertexOut vertexOut;
    vertexOut.position = pixelPositionIn4D;
    vertexOut.texCoords = vertexIn[vid].texCoords;
    
    return vertexOut;
    
}

fragment half4 sprite_fragment(VertexIn vertexMap [[ stage_in ]],
                               constant FragmentUniforms &uniforms [[ buffer(0) ]],
                               texture2d<float, access::sample> texture [[ texture(0) ]]) {
    
    constexpr sampler s(address::clamp_to_edge, filter::linear);
    
    float4 color = texture.sample(s, vertexMap.texCoords);
    
    if (uniforms.color.a == 0.0) {
        return half4(0, 0, 0, 0);
    }
    
    return half4(color.r * uniforms.brightness * uniforms.color.r,
                 color.g * uniforms.brightness * uniforms.color.g,
                 color.b * uniforms.brightness * uniforms.color.b,
                 color.a);
    
}


