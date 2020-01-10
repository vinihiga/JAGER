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
    private var metalLayer: CAMetalLayer!
    private var vertexBuffer: MTLBuffer!
    private var pipelineState: MTLRenderPipelineState!
    private var commandQueue: MTLCommandQueue!
    
    private var timer: CADisplayLink! // This type is synchronized to the display refresh rate
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.device = MTLCreateSystemDefaultDevice()
                       
        self.metalLayer = CAMetalLayer()          // 1
        self.metalLayer.device = self.device      // 2
        self.metalLayer.pixelFormat = .bgra8Unorm // 3
        self.metalLayer.framebufferOnly = true    // 4
        self.metalLayer.frame = view.layer.frame  // 5
        view.layer.addSublayer(self.metalLayer)   // 6

        let vertexData: [Float] = [
          0.0,  1.0, 0.0,
         -1.0, -1.0, 0.0,
          1.0, -1.0, 0.0
        ]

        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 1
        self.vertexBuffer = self.device.makeBuffer(bytes: vertexData, length: dataSize, options: []) // 2

        // 1
        let defaultLibrary = self.device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
           
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
           
        // 3
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

        self.commandQueue = self.device.makeCommandQueue()
        
        self.timer = CADisplayLink(target: self, selector: #selector(tick))
        self.timer.add(to: RunLoop.main, forMode: .default)
    }
    
    private func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
          red: 0.0,
          green: 0.0,
          blue: 0.0,
          alpha: 1.0)
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()
        
        let renderEncoder = commandBuffer!
          .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder
          .drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        
        renderEncoder.endEncoding()


        commandBuffer!.present(drawable)
        commandBuffer!.commit()
        
    }
    
    @objc func tick() {
        autoreleasepool {
            self.render()
        }
    }
    
}
