//
//  ShaderDefinitions.h
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 11/01/20.
//

#ifndef ShaderDefinitions_h
#define ShaderDefinitions_h

struct FragmentUniforms {
    float brightness;
};

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float2 texCoords [[ attribute(1) ]];
};

#endif /* ShaderDefinitions_h */
