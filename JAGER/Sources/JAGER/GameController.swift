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
    
    private var entities = [Entity]()

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
        
        // Creating and initializing the Game's main loop
        self.variableTimeUpdater = CADisplayLink(target: self, selector: #selector(tick))
        self.variableTimeUpdater.add(to: RunLoop.main, forMode: .default)
        
    }

    
    
    /// Main Game Loop.
    @objc private func tick() {
        autoreleasepool {
            
            if (self.previousFrameTime != 0) {
                
                let deltaTime = Date().timeIntervalSince1970 - self.previousFrameTime
                
                // Physics related
                self.recalculateDynamics()
                
                // Update Entities
                self.updateEntities(deltaTime: deltaTime)
                
                // Rendering related
                self.prepareRender(deltaTime: deltaTime)
                
            }
            
            self.previousFrameTime = Date().timeIntervalSince1970
            
        }
    }
    
    
    
    /// Handles the Physics on the Entities.
    private func recalculateDynamics() {
        for entity in self.entities {
            if entity.rigidBody != nil {
                if entity.rigidBody!.isEnabled {
                    entity.rigidBody!.fall(force: Physics.addForce(mass: 1.0, acceleration: Physics.EARTH_GRAVITY_ACCEL))
                }
            }
        }
    }
    
    
    
    /// Handles the Entities ticks (user setted some sort of update) or removes from the memory.
    /// - Parameter deltaTime: The frame delta time in relation of the previous and current frame time.
    private func updateEntities(deltaTime: TimeInterval) {
        
        var currentIndex = 0
        
        // TODO: I think there is some sort of algorithm / data structure that is more faster for handling memory...
        while currentIndex < self.entities.count {
            if self.entities[currentIndex].isSetToDestroy {
                self.entities.remove(at: currentIndex)
            }
            else {
                self.entities[currentIndex].tick(deltaTime: deltaTime)
                currentIndex += 1
            }
        }
    }
    
    
    
    
    /// Handles the draw calls.
    /// - Parameter deltaTime: The frame delta time in relation of the previous and current frame time.
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

        
        currentRenderEncoder.endEncoding()
        commandBuffer!.present(drawable!)
        commandBuffer!.commit() // NOTE: Here is where we really draw the sprites on the GPU

    }
    
    
    
    /// Renders the sprites on the screen.
    /// NOTE: This is called by default after the physics and input calculation!
    /// - Parameters:
    ///   - deltaTime: The frame delta time in relation of the previous and current frame time.
    ///   - currentRenderEncoder: (DO NOT MODIFY) Current Render Encoder of the GPU.
    private func render(deltaTime: TimeInterval, currentRenderEncoder: MTLRenderCommandEncoder) {
        
        for entity in self.entities {
            entity.sprite.draw(renderCommandEncoder: currentRenderEncoder, renderPipelineManager: self.renderPipelineManager)
        }
        
    }
    
    
    
    /// Adds a new entity into the current scene.
    /// - Parameter entity: A desired entity or inherited class instance that derives from entity to be added
    public func addEntity(_ entity: Entity) {
        self.entities.append(entity)
    }
    
}
