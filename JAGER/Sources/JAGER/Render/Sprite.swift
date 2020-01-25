//
//  Quad.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 17/01/20.
//

import Foundation
import Metal
import MetalKit
import CoreGraphics

public struct Shaders {
    var vertexName: String
    var fragmentName: String
}

public class Sprite {
    
    public var color: SIMD3<Float>!
    public var position: CGPoint { get { return self.entity?.position ?? CGPoint.zero } }
    public var size: CGSize!
    public var isHidden: Bool!
    
    private var controller: GameController!
    private var entity: Entity?
    private var loader: MTKTextureLoader!
    private var verticesBuffer: MTLBuffer!
    private var indexesBuffer: MTLBuffer!
    private var fragmentBuffer: MTLBuffer!
    
    private var vertices: [Vertex]!
    private var indexes: [UInt16]!
    
    private var texture: MTLTexture?
    private var shaders: Shaders?
    
    init(controller: GameController, entity: Entity, size: CGSize, color: SIMD3<Float>) {
        
        self.controller = controller
        
        self.color = color
        self.size = size
        self.entity = entity
        
        self.isHidden = false
        
        self.loader = MTKTextureLoader(device: controller.device)
        
        
    }
    
    
    
    init(controller: GameController, entity: Entity, size: CGSize, color: SIMD3<Float>, customShaders: Shaders, texture: String) {
        
        self.controller = controller
        
        self.color = color
        self.size = size
        self.entity = entity
        
        self.isHidden = false
        
        self.shaders = customShaders
        self.loader = MTKTextureLoader(device: controller.device)
        
        do {
            let url = self.controller.gameBundle.url(forResource: texture, withExtension: "png")
            self.texture = try self.loader!.newTexture(URL: url!, options: nil)
        }
        catch {
            fatalError("Error! No texture with name \(texture) found on Game Bundle!")
        }
        
        
    }
    
    
    
    /// Draws the Quad into the screen by passing the Render Command Encoder.
    /// - Parameter renderCommandEncoder: Render Command Encoder for passing into the GPU.
    func draw(renderCommandEncoder: MTLRenderCommandEncoder, renderPipelineManager: RenderPipelineManager) {
        
        self.mountBuffers()
        
        if self.shaders == nil {
            renderCommandEncoder.setRenderPipelineState(renderPipelineManager.mountRenderPipelineState(
                vertexShader: "basic_vertex",
                fragmentShader: "basic_fragment"))
            
            renderCommandEncoder.setVertexBuffer(self.verticesBuffer, offset: 0, index: 0)
            renderCommandEncoder.setVertexBuffer(self.controller.viewportSizeBuffer, offset: 0, index: 1)
            renderCommandEncoder.setFragmentBuffer(self.fragmentBuffer, offset: 0, index: 0)
        }
        else {
            renderCommandEncoder.setRenderPipelineState(renderPipelineManager.mountRenderPipelineState(
                vertexShader: "sprite_vertex",
                fragmentShader: "sprite_fragment"))
            
            renderCommandEncoder.setVertexBuffer(self.verticesBuffer, offset: 0, index: 0)
            renderCommandEncoder.setVertexBuffer(self.controller.viewportSizeBuffer, offset: 0, index: 1)
            renderCommandEncoder.setFragmentBuffer(self.fragmentBuffer, offset: 0, index: 0)
            renderCommandEncoder.setFragmentTexture(self.texture, index: 0)
        }

        renderCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.indexes.count, indexType: .uint16, indexBuffer: self.indexesBuffer!, indexBufferOffset: 0)
        
    }
    
    
    
    /// Genrates the Vertices and the Fragments buffers for the draw method.
    private func mountBuffers() {
        
        self.vertices = [
            // Top-Left
            Vertex(
                position: SIMD4<Float>(Float(position.x - size.width / 2.0), Float(position.y + size.height / 2.0), 0.0, 1.0),
                texCoords: SIMD2<Float>(0.0, 1.0)
            ),
            // Bottom-Left
            Vertex(
                position: SIMD4<Float>(Float(position.x - size.width / 2.0), Float(position.y - size.height / 2.0), 0.0, 1.0),
                texCoords: SIMD2<Float>(0.0, 0.0)
            ),
            // Top-Right
            Vertex(
                position: SIMD4<Float>(Float(position.x + size.width / 2.0), Float(position.y + size.height / 2.0), 0.0, 1.0),
                texCoords: SIMD2<Float>(1.0, 1.0)
            ),
            // Bottom-Right
            Vertex(
                position: SIMD4<Float>(Float(position.x + size.width / 2.0), Float(position.y - size.height / 2.0), 0.0, 1.0),
                texCoords: SIMD2<Float>(1.0, 0.0)
            )
        ]
        
        
        self.indexes = [
            0, 1, 2,
            2, 1, 3
        ]
        
        
        var alpha: Float = 1.0
        
        if self.isHidden {
            alpha = 0.0
        }

        let colorWithAlpha = SIMD4<Float>(self.color.x, self.color.y, self.color.z, alpha)
        let fragmentUniforms = [Fragment(brightness: 1.0, color: colorWithAlpha)]
        
        
        self.verticesBuffer = self.controller.device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: []) // Buffer 1
        self.indexesBuffer = self.controller.device.makeBuffer(bytes: indexes, length: indexes.count * MemoryLayout<UInt16>.stride, options: []) // Buffer 2
        self.fragmentBuffer = self.controller.device.makeBuffer(bytes: fragmentUniforms, length: fragmentUniforms.count * MemoryLayout<Fragment>.stride, options: []) // Buffer 3
        
    }
    
}
