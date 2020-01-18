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
    private var renderPipelineManager: RenderPipelineManager!
    private var timer: CADisplayLink! // Synchronized to the display refresh rate
    private var gameBundle: Bundle!

    open func viewDidLoad(bundle: Bundle) {
        super.viewDidLoad()
        
        self.device = MTLCreateSystemDefaultDevice()
        self.gameBundle = bundle
        self.renderPipelineManager = RenderPipelineManager(view: self.view, device: self.device)
        
        self.timer = CADisplayLink(target: self, selector: #selector(tick))
        self.timer.add(to: RunLoop.main, forMode: .default)
    }
    
    
    
    /// Handles the draw calls.
    private func render() {
        
        guard let metalLayer = self.renderPipelineManager.metalLayer else {
            fatalError("Error! Couldn't load the metal layer!")
        }
        
        let drawable = metalLayer.nextDrawable()
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable?.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
          red: 0.0,
          green: 0.0,
          blue: 1.0,
          alpha: 1.0)
        
        

        let commandBuffer = device.makeCommandQueue()?.makeCommandBuffer()
        let renderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        // Calculating the current viewport size
        var viewportSize = [Float32]()
        let frame = self.view.frame
        
        viewportSize.append(Float32(frame.width))
        viewportSize.append(Float32(frame.height))
        
        let viewportSizeBuffer = self.device.makeBuffer(bytes: viewportSize, length: viewportSize.count * MemoryLayout<Float32>.stride, options: [])
        
        
        
        // Drawing the sprites / game objects now...

        let quad = Quad(
            device: self.device,
            viewportSizeBuffer: viewportSizeBuffer!,
            size: CGSize(width: 64, height: 64),
            position: CGPoint(x: 0, y: 0),
            color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0))
        
        quad.draw(renderCommandEncoder: renderEncoder, renderPipelineManager: self.renderPipelineManager)


        
        // End of "drawing" the sprites... Drawing physically now!
        renderEncoder.endEncoding()
        commandBuffer!.present(drawable!)
        commandBuffer!.commit() // Here is where we really draw the sprites

    }
    
    
    
    /// Main Game Loop.
    @objc func tick() {
        autoreleasepool {
            self.render()
            //print("Frame finished")
        }
    }
    
}
