//
//  RenderingManager.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 11/01/20.
//

import Foundation
import Metal
import MetalKit
import QuartzCore
import UIKit

public class RenderPipelineManager {
    
    // Default properties related to the rendering pipeline
    private var controller: Game!
    private var device: MTLDevice!
    private static var instance: RenderPipelineManager?
    public var metalLayer: CAMetalLayer?

    
    /// Default private initializer for creating the Rendering Pipeline Manager.
    /// - Parameters:
    ///   - controller: The main game controller
    ///   - device: GPU interface for passing buffers.
    private init(controller: Game, device: MTLDevice) {
        
        self.controller = controller
        self.device = device
        self.metalLayer = CAMetalLayer()
        
        self.metalLayer!.device = device
        self.metalLayer!.pixelFormat = .bgra8Unorm
        self.metalLayer!.framebufferOnly = true
        self.metalLayer!.frame = self.controller.view.layer.frame
        
        self.metalLayer!.zPosition = -1
        
        self.controller.view.layer.addSublayer(self.metalLayer!)
        
    }
    
    
    
    /// Handles the draw calls related to sprites and texture based objects.
    /// NOTE: This is called by default after the physics and entities updates!
    public func renderSprites(scene: Scene) {
        
        guard let metalLayer = self.metalLayer else {
            fatalError("Error! Couldn't load the metal layer!")
        }
        
        let drawable = metalLayer.nextDrawable()
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable?.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
                                                                      red: 0.0,
                                                                      green: 0.0,
                                                                      blue: 0.0,
                                                                      alpha: 1.0)
        
        

        let commandBuffer = device.makeCommandQueue()?.makeCommandBuffer()
        let currentRenderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        

        // Rendering the Sprites...
        for entity in scene.entities {
            entity.sprite?.draw(renderCommandEncoder: currentRenderEncoder, renderPipelineManager: self)
        }
        
        currentRenderEncoder.endEncoding()
        commandBuffer!.present(drawable!)
        commandBuffer!.commit() // NOTE: Here is where we really draw the sprites on the GPU

    }
    
    
    
    /// Mounts the current Pipeline State for the current frame.
    /// - Parameters:
    ///   - vertexShader: Vertex Shader function name
    ///   - fragmentShader: Fragment Shader function name
    public func mountRenderPipelineState(vertexShader: String, fragmentShader: String) -> MTLRenderPipelineState {
        
        do {

            // Loading the shaders programs (vertex & fragment / pixel)
            let defaultLibrary = try device.makeDefaultLibrary(bundle: Bundle.main)
            let vertexProgram = defaultLibrary.makeFunction(name: vertexShader)
            let fragmentProgram = defaultLibrary.makeFunction(name: fragmentShader)
               
            // Building the description for the graphics pipeline
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = vertexProgram
            pipelineStateDescriptor.fragmentFunction = fragmentProgram
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            //pipelineStateDescriptor.sampleCount = 4
            
            // Setting the blending configurations
            pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
            pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
            pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
            pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
            pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
               
            // Loading the updated pipeline state
            let pipelineState = try self.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

            return pipelineState
            
        }
        catch {
            fatalError("[FATAL ERROR] \(error)")
        }
        
    }
    
    
    
    /// Creates or load a previous instance of the Render Pipeline Manager
    /// - Parameters:
    ///   - view: Main UIView for creating the Metal Layer for rendering 2D/3D graphics.
    ///   - device: GPU interface for passing buffers.
    static public func getInstance(controller: Game, device: MTLDevice) -> RenderPipelineManager {
        
        if RenderPipelineManager.instance == nil {
            RenderPipelineManager.instance = RenderPipelineManager(controller: controller, device: device)
        }
        
        return RenderPipelineManager.instance!
    }
}
