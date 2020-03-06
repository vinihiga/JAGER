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
    
    private var controller: GameController!
    private var device: MTLDevice!
    private static var instance: RenderPipelineManager?
    
    public var metalLayer: CAMetalLayer?

    

    // TODO: Remake the description...
    private init(controller: GameController, device: MTLDevice) {
        
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
    static public func getInstance(controller: GameController, device: MTLDevice) -> RenderPipelineManager {
        
        if RenderPipelineManager.instance == nil {
            RenderPipelineManager.instance = RenderPipelineManager(controller: controller, device: device)
        }
        
        return RenderPipelineManager.instance!
    }
}
