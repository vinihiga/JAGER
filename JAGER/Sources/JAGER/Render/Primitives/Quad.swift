//
//  Quad.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 17/01/20.
//

import Foundation
import Metal

public class Quad {
    
    private var verticesBuffer: MTLBuffer!
    private var indexesBuffer: MTLBuffer!
    private var fragmentUniformsBuffer: MTLBuffer!
    
    private var vertices: [Vertex]!
    private var indexes: [UInt16]!
    
    public init(device: MTLDevice) {
        
        self.vertices = [
            Vertex(position: SIMD4<Float>(-0.5, 0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0)),
            Vertex(position: SIMD4<Float>(-0.5, -0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0)),
            Vertex(position: SIMD4<Float>(0.5, 0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0)),
            Vertex(position: SIMD4<Float>(0.5, -0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0))
        ]
        
        self.indexes = [
            0, 1, 2,
            2, 1, 3
        ]
        
        
        let fragmentUniforms = [FragmentUniforms(brightness: 1.0)]
        
        
        self.verticesBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        
        self.indexesBuffer = device.makeBuffer(bytes: indexes, length: indexes.count * MemoryLayout<UInt16>.stride, options: [])
        
        self.fragmentUniformsBuffer = device.makeBuffer(bytes: fragmentUniforms, length: fragmentUniforms.count * MemoryLayout<FragmentUniforms>.stride, options: [])
        
        
        
    }
    
    
    
    /// Draws the Quad into the screen by passing the Render Command Encoder.
    /// - Parameter renderCommandEncoder: Render Command Encoder for passing into the GPU.
    public func draw(renderCommandEncoder: MTLRenderCommandEncoder, renderPipelineManager: RenderPipelineManager) {
        
        renderCommandEncoder.setRenderPipelineState(renderPipelineManager
            .mountRenderPipelineState(vertexShader: "basic_vertex", fragmentShader: "basic_fragment"))
        
        renderCommandEncoder.setVertexBuffer(self.verticesBuffer, offset: 0, index: 0)
        renderCommandEncoder.setFragmentBuffer(self.fragmentUniformsBuffer, offset: 0, index: 0)


        renderCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.indexes.count, indexType: .uint16, indexBuffer: self.indexesBuffer!, indexBufferOffset: 0)
    }
    
}
