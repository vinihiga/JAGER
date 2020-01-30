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
    
    // Getting the positions in each vertex, getting the viewport size
    float2 vertexPosition = vertexIn[vid].position.xy;
    //float2 vertexCenter = vertexIn[vid].center.xy;
    float2 viewportSize = float2(*viewportSizePtr);
    
    // Converting the Model Position to World Position
    float4 vertexSpacePosition = float4(vertexPosition.x / viewportSize.x, vertexPosition.y / viewportSize.y, 0, 1.0);
    
    // Re-mapping the vertex with new world position and setting it's semantic to POSITION
    VertexOut vertexOut;
    vertexOut.position = vertexSpacePosition;
    vertexOut.texCoords = vertexIn[vid].texCoords;

    return vertexOut;
    
}




fragment half4 sprite_fragment(VertexIn vertexMap [[ stage_in ]],
                               constant FragmentUniforms &uniforms [[ buffer(0) ]],
                               texture2d<float, access::sample> texture [[ texture(0) ]]) {
    
    // Calculating the factor for each axis
    float cosFactor = cos(uniforms.eulerAngle * M_PI_F / 180.0);
    float sinFactor = sin(uniforms.eulerAngle * M_PI_F / 180.0);
    
    // Calculating the Rotation Matrix by each axis invidually
    float newX = 0.5 + (vertexMap.texCoords.x -0.5) * cosFactor - (vertexMap.texCoords.y -0.5) * sinFactor;
    float newY = 0.5 + (vertexMap.texCoords.x -0.5) * sinFactor + (vertexMap.texCoords.y -0.5) * cosFactor;
    
    float2 texCoordsRotated = float2(newX, newY);
    
    constexpr sampler s(address::clamp_to_edge, filter::linear);
    float4 color = texture.sample(s, texCoordsRotated);
    
    if (uniforms.color.a == 0.0) {
        return half4(0, 0, 0, 0);
    }
    
    return half4(color.r * uniforms.brightness * uniforms.color.r,
                 color.g * uniforms.brightness * uniforms.color.g,
                 color.b * uniforms.brightness * uniforms.color.b,
                 color.a);
    
}


