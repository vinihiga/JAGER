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

// TODO: Transformar para singleton
public class RenderPipelineManager {
    
    private var view: UIView!
    private var device: MTLDevice!
    
    public var metalLayer: CAMetalLayer?

    init(view: UIView, device: MTLDevice) {
        
        self.view = view
        self.device = device
        self.metalLayer = CAMetalLayer()
        
        self.metalLayer!.device = device
        self.metalLayer!.pixelFormat = .bgra8Unorm
        self.metalLayer!.framebufferOnly = true
        self.metalLayer!.frame = view.layer.frame
        
        self.metalLayer!.zPosition = -1
        
        view.layer.addSublayer(self.metalLayer!)
        

        
    }
    
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
    
}
