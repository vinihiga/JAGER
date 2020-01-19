//
//  Quad.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 17/01/20.
//

import Foundation
import Metal
import CoreGraphics

public class Sprite {
    
    public var color: SIMD4<Float>!
    public var position: CGPoint { get { return self.entity?.position ?? CGPoint.zero } }
    public var size: CGSize!
    
    private var controller: GameController!
    private var entity: Entity?
    private var verticesBuffer: MTLBuffer!
    private var indexesBuffer: MTLBuffer!
    private var fragmentUniformsBuffer: MTLBuffer!
    
    private var vertices: [Vertex]!
    private var indexes: [UInt16]!
    
    init(controller: GameController, entity: Entity, size: CGSize, color: SIMD4<Float>) {
        
        self.controller = controller
        
        self.color = color
        self.size = size
        self.entity = entity
        
        
    }
    
    
    
    /// Draws the Quad into the screen by passing the Render Command Encoder.
    /// - Parameter renderCommandEncoder: Render Command Encoder for passing into the GPU.
    func draw(renderCommandEncoder: MTLRenderCommandEncoder, renderPipelineManager: RenderPipelineManager) {
        
        self.mountGeometryBuffer()
        
        renderCommandEncoder.setRenderPipelineState(renderPipelineManager.mountRenderPipelineState(vertexShader: "basic_vertex", fragmentShader: "basic_fragment"))
        
        renderCommandEncoder.setVertexBuffer(self.verticesBuffer, offset: 0, index: 0)
        renderCommandEncoder.setVertexBuffer(self.controller.viewportSizeBuffer, offset: 0, index: 1)
        renderCommandEncoder.setFragmentBuffer(self.fragmentUniformsBuffer, offset: 0, index: 0)

        renderCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.indexes.count, indexType: .uint16, indexBuffer: self.indexesBuffer!, indexBufferOffset: 0)
        
    }
    
    
    
    /// Genrates the Vertices and the Fragments buffers for the draw method.
    private func mountGeometryBuffer() {
        
        self.vertices = [
            Vertex(
                position: SIMD4<Float>(Float(position.x - size.width / 2.0), Float(position.y + size.height / 2.0), 0.0, 1.0),
                texCoords: SIMD2<Float>(repeating: 0.0)
            ),
            Vertex(
                position: SIMD4<Float>(Float(position.x - size.width / 2.0), Float(position.y - size.height / 2.0), 0.0, 1.0),
                texCoords: SIMD2<Float>(repeating: 0.0)
            ),
            Vertex(
                position: SIMD4<Float>(Float(position.x + size.width / 2.0), Float(position.y + size.height / 2.0), 0.0, 1.0),
                texCoords: SIMD2<Float>(repeating: 0.0)
            ),
            Vertex(
                position: SIMD4<Float>(Float(position.x + size.width / 2.0), Float(position.y - size.height / 2.0), 0.0, 1.0),
                texCoords: SIMD2<Float>(repeating: 0.0)
            )
        ]
        
        self.indexes = [
            0, 1, 2,
            2, 1, 3
        ]
        
        
        let fragmentUniforms = [FragmentUniforms(brightness: 1.0, color: color)]
        
        
        self.verticesBuffer = self.controller.device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        
        self.indexesBuffer = self.controller.device.makeBuffer(bytes: indexes, length: indexes.count * MemoryLayout<UInt16>.stride, options: [])
        
        self.fragmentUniformsBuffer = self.controller.device.makeBuffer(bytes: fragmentUniforms, length: fragmentUniforms.count * MemoryLayout<FragmentUniforms>.stride, options: [])
        
        
    }
    
    
}
