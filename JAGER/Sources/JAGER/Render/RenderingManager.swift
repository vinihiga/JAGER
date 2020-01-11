//
//  RenderingManager.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 11/01/20.
//

import Foundation
import Metal
import QuartzCore
import UIKit

struct FragmentUniforms {
    var brightness: Float
}

// TODO: Transformar para singleton
class RenderingManager {
    
    private var view: UIView!
    
    public var device: MTLDevice!
    public var metalLayer: CAMetalLayer?
    public var commandQueue: MTLCommandQueue?
    public var vertexBuffer: MTLBuffer?
    public var pipelineState: MTLRenderPipelineState?
    
    init(view: UIView) {
        
        self.view = view
        self.device = MTLCreateSystemDefaultDevice()
        self.metalLayer = CAMetalLayer()
        
        self.metalLayer!.device = self.device
        self.metalLayer!.pixelFormat = .bgra8Unorm
        self.metalLayer!.framebufferOnly = true
        self.metalLayer!.frame = view.layer.frame
        view.layer.addSublayer(self.metalLayer!)
        
        let vertexData: [Float] = [
          0.0,  0.5, 0.0,
         -0.5, -0.5, 0.0,
          0.5, -0.5, 0.0
        ]
        
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        self.vertexBuffer = self.device.makeBuffer(bytes: vertexData, length: dataSize, options: [])

        let frameworkBundle = Bundle(for: type(of: self))
        
        do {
            
            // Loading the shaders programs (vertex & fragment / pixel)
            let defaultLibrary = try self.device?.makeDefaultLibrary(bundle: frameworkBundle)
            let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
            let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
               
            // Building the description for the graphics pipeline
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = vertexProgram
            pipelineStateDescriptor.fragmentFunction = fragmentProgram
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
//            pipelineStateDescriptor.setValue(1.0, forKey: "deltaTime")
               
            // Loading the updated pipelijne state
            pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

        }
        catch {
            fatalError("Error! Couldn't load the shader files!")
        }
        
        self.commandQueue = self.device.makeCommandQueue()

        
    }
    
}
