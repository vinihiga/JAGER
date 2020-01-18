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
    
    private(set) var device: MTLDevice!
    private(set) var viewportSizeBuffer: MTLBuffer!
    
    private var renderPipelineManager: RenderPipelineManager!
    private var variableTimeUpdater: CADisplayLink! // Used for Physics, Rendering, Networking, HUD and Input
    private var previousFrameTime: TimeInterval = 0
    private var gameBundle: Bundle!
    
    private var player: Player!

    open func viewDidLoad(bundle: Bundle) {
        super.viewDidLoad()
        
        self.device = MTLCreateSystemDefaultDevice()
        self.gameBundle = bundle
        self.renderPipelineManager = RenderPipelineManager(view: self.view, device: self.device)
        
        // TODO: Make change the viewport size when the screen rotates...
        // Calculating the current viewport size
        var viewportSize = [Float32]()
        let frame = self.view.frame
        
        viewportSize.append(Float32(frame.width))
        viewportSize.append(Float32(frame.height))
        
        self.viewportSizeBuffer = self.device.makeBuffer(bytes: viewportSize, length: viewportSize.count * MemoryLayout<Float32>.stride, options: [])
        
        self.player = Player(
            gameController: self,
            size: CGSize(width: 64, height: 64),
            position: CGPoint(x: 0, y: 0),
            color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0))
        
        self.variableTimeUpdater = CADisplayLink(target: self, selector: #selector(tick))
        self.variableTimeUpdater.add(to: RunLoop.main, forMode: .default)
        
    }
    
    /// Handles the draw calls.
    private func prepareRender(deltaTime: TimeInterval) {
        
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
          blue: 0.2,
          alpha: 1.0)
        
        

        let commandBuffer = device.makeCommandQueue()?.makeCommandBuffer()
        let currentRenderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        

        self.render(deltaTime: deltaTime, currentRenderEncoder: currentRenderEncoder)

        
        // End of "drawing" the sprites... Drawing physically now!
        currentRenderEncoder.endEncoding()
        commandBuffer!.present(drawable!)
        commandBuffer!.commit() // Here is where we really draw the sprites

    }
    
    /// Main Game Loop.
    @objc private func tick() {
        autoreleasepool {
            
            if (self.previousFrameTime != 0) {
                
                let deltaTime = Date().timeIntervalSince1970 - self.previousFrameTime
                
                // Physics related
                self.player.rigidBody.currentFallingSpeed += 9.807 * 1/60 // TODO: Calculate current fps and divide by one
                self.player.position.y -= self.player.rigidBody.currentFallingSpeed
                
                
                // Rendering related
                self.prepareRender(deltaTime: deltaTime)
                
            }
            
            self.previousFrameTime = Date().timeIntervalSince1970
            
        }
    }
    
    public func render(deltaTime: TimeInterval, currentRenderEncoder: MTLRenderCommandEncoder) {
        
        // Drawing the sprites / game objects now...
        self.player.color = SIMD4<Float>(Float(0.5),
                                         Float(0.5 + 0.5 * sin(Date().timeIntervalSince1970)),
                                         Float(0.5 + 0.5 * cos(Date().timeIntervalSince1970)),
                                         Float(1.0))
        

        self.player.draw(renderCommandEncoder: currentRenderEncoder, renderPipelineManager: self.renderPipelineManager)

        
    }
    
}
