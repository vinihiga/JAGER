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

struct FragmentUniforms {
    var brightness: Float
    var color: SIMD4<Float>
}

public class RenderPipelineManager {
    
    private var view: UIView!
    private var device: MTLDevice!
    private static var instance: RenderPipelineManager?
    
    public var metalLayer: CAMetalLayer?

    
    
    /// Default private initializer for creating the Rendering Pipeline Manager.
    /// - Parameters:
    ///   - view: Main UIView for creating the Metal Layer for rendering 2D/3D graphics.
    ///   - device: GPU interface for passing buffers.
    private init(view: UIView, device: MTLDevice) {
        
        self.view = view
        self.device = device
        self.metalLayer = CAMetalLayer()
        
        self.metalLayer!.device = device
        self.metalLayer!.pixelFormat = .bgra8Unorm
        self.metalLayer!.framebufferOnly = true
        self.metalLayer!.frame = view.layer.frame
        
        self.metalLayer!.zPosition = -1
        
        view.layer.addSublayer(self.metalLayer!) // TODO: Adicionar um deinit para remover essa layer do metal quando finalizar o jogo?
        
    }
    
    
    
    
    /// Mounts the current Pipeline State for the current frame.
    /// - Parameters:
    ///   - vertexShader: Vertex Shader function name
    ///   - fragmentShader: Fragment Shader function name
    public func mountRenderPipelineState(vertexShader: String, fragmentShader: String) -> MTLRenderPipelineState {
        
        do {
            
            let frameworkBundle = Bundle(for: type(of: self))
            
            // Loading the shaders programs (vertex & fragment / pixel)
            let defaultLibrary = try device.makeDefaultLibrary(bundle: frameworkBundle)
            let vertexProgram = defaultLibrary.makeFunction(name: vertexShader)
            let fragmentProgram = defaultLibrary.makeFunction(name: fragmentShader)
               
            // Building the description for the graphics pipeline
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = vertexProgram
            pipelineStateDescriptor.fragmentFunction = fragmentProgram
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
               
            // Loading the updated pipeline state
            let pipelineState = try self.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

            return pipelineState
            
        }
        catch {
            fatalError("Error! Couldn't generate the Render Pipeline State!")
        }
        
    }
    
    
    
    
    /// Creates or load a previous instance of the Render Pipeline Manager
    /// - Parameters:
    ///   - view: Main UIView for creating the Metal Layer for rendering 2D/3D graphics.
    ///   - device: GPU interface for passing buffers.
    static public func getInstance(view: UIView, device: MTLDevice) -> RenderPipelineManager {
        
        if RenderPipelineManager.instance == nil {
            RenderPipelineManager.instance = RenderPipelineManager(view: view, device: device)
        }
        
        return RenderPipelineManager.instance!
    }
}
