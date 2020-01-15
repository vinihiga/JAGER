//
//  Application.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 10/01/20.
//  Copyright © 2020 Vini Games. All rights reserved.
//

import Foundation
import Metal
import QuartzCore
import UIKit

open class GameController: UIViewController {
    
    private var device: MTLDevice!
    private var renderingManager: RenderingManager!
    private var timer: CADisplayLink! // Synchronized to the display refresh rate
    private var gameBundle: Bundle!
    private var renderPipelineState: MTLRenderPipelineState?
    private var drawable: CAMetalDrawable!
    
    open func viewDidLoad(bundle: Bundle) {
        super.viewDidLoad()
        
        self.device = MTLCreateSystemDefaultDevice()
        self.gameBundle = bundle
        self.renderingManager = RenderingManager(view: self.view, device: self.device)
        
        guard let metalLayer = self.renderingManager.metalLayer else {
            fatalError("Error! Couldn't load the metal layer!")
        }
        
        self.drawable = metalLayer.nextDrawable()
        
        self.timer = CADisplayLink(target: self, selector: #selector(tick))
        self.timer.add(to: RunLoop.main, forMode: .default)
    }
    
    
    
    /// Method for handling the draw calls.
    private func render() {
        
        
        /* -------------------------------------------------------------------- */
        // Clearing the current frame buffer and preparing for drawing new data
        /* -------------------------------------------------------------------- */
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = self.drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
          red: 0.0,
          green: 0.0,
          blue: 1.0,
          alpha: 1.0)
        
        

        var commandBuffer = device.makeCommandQueue()?.makeCommandBuffer()
        
        var renderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        // Drawing the sprites

        renderEncoder.setRenderPipelineState(self.renderingManager
            .mountRenderPipelineState(vertexShader: "basic_vertex", fragmentShader: "basic_fragment"))
        
        
        
        
        
        
        
        
        let vertices_1 = [
            Vertex(position: SIMD4<Float>(-0.5, 0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0)),
            Vertex(position: SIMD4<Float>(0.5, 0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0)),
            Vertex(position: SIMD4<Float>(0.5, -0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0))
        ]
        
        let fragmentUniforms = [FragmentUniforms(brightness: 1.0)]
        
        
        let vertexBuffer_1 = self.device.makeBuffer(bytes: vertices_1, length: vertices_1.count * MemoryLayout<Vertex>.stride, options: [])
        let fragmentUniformsBuffer = self.device.makeBuffer(bytes: fragmentUniforms, length: fragmentUniforms.count * MemoryLayout<FragmentUniforms>.stride, options: [])
        
        renderEncoder.setVertexBuffer(vertexBuffer_1, offset: 0, index: 0)
        renderEncoder.setFragmentBuffer(fragmentUniformsBuffer, offset: 0, index: 0)

        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)

        
        
        
        
        
        
        
        let vertices_2 = [
           Vertex(position: SIMD4<Float>(-0.5, 0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0)),
           Vertex(position: SIMD4<Float>(0.5, -0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0)),
           Vertex(position: SIMD4<Float>(-0.5, -0.5, 0.0, 1.0), texCoords: SIMD2<Float>(repeating: 0.0))
        ]


        let vertexBuffer_2 = self.device.makeBuffer(bytes: vertices_2, length: vertices_2.count * MemoryLayout<Vertex>.stride, options: [])

        renderEncoder.setVertexBuffer(vertexBuffer_2, offset: 0, index: 0)
        renderEncoder.setFragmentBuffer(fragmentUniformsBuffer, offset: 0, index: 0)

        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
       
        
        
        
        
        
        
        
        
        
        // End of "drawing" the sprites
        
        renderEncoder.endEncoding()
        
        commandBuffer!.present(drawable)
        commandBuffer!.commit() // Here is where we really draw the sprites

        
        
        
        
        
        
        
        
        
        




    }
    
    
    
    /// Method for handling the main game loop.
    @objc func tick() {
        autoreleasepool {
            self.render()
            //print("Frame finished")
        }
    }
    
}
