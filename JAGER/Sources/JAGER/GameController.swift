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
    
    private var renderingManager: RenderingManager!
    private var timer: CADisplayLink! // This type is synchronized to the display refresh rate
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.renderingManager = RenderingManager(view: self.view)
        
        self.timer = CADisplayLink(target: self, selector: #selector(tick))
        self.timer.add(to: RunLoop.main, forMode: .default)
    }
    
    
    
    /// Method for handling the draw calls.
    private func render() {
        
        
        /* -------------------------------------------------------------------- */
        // Clearing the current frame buffer and preparing for drawing new data
        /* -------------------------------------------------------------------- */
        
        guard let metalLayer = self.renderingManager.metalLayer else {
            fatalError("Error! Couldn't load the metal layer!")
        }
        
        guard let drawable = metalLayer.nextDrawable() else { return }
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
          red: 0.0,
          green: 0.0,
          blue: 0.0,
          alpha: 1.0)
        
        guard let commandQueue = self.renderingManager.commandQueue else {
            return
        }
        
        
        
        /* ----------------------------------------------------------------------------- */
        // Creating the commands for rendering meshes / models / sprites into the screen
        /* ----------------------------------------------------------------------------- */
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        guard let pipelineState = self.renderingManager.pipelineState else {
            fatalError("Error! Couldn't load the pipeline state!")
        }
        
        guard let vertexBuffer = self.renderingManager.vertexBuffer else {
            fatalError("Error! Couldn't load the vertex buffer!")
        }
        
        var initialFragmentUniforms = FragmentUniforms(brightness: 1.0)
        let fragmentUniformsBuffer = self.renderingManager.device.makeBuffer(bytes: &initialFragmentUniforms, length: MemoryLayout<FragmentUniforms>.stride, options: [])!
        
        let renderEncoder = commandBuffer!
            .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentBuffer(fragmentUniformsBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        
        renderEncoder.endEncoding()


        commandBuffer!.present(drawable)
        commandBuffer!.commit()
        
    }
    
    
    
    /// Method for handling the main game loop.
    @objc func tick() {
        autoreleasepool {
            self.render()
        }
    }
    
}
