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
import CoreGraphics

open class GameController: UIViewController {
    
    // Game Engine global parameters
    public static let REQUIRED_FRAMETIME: Int = 60
    
    // GPU Variables
    public var device: MTLDevice! // TODO: Create a GET only property for outside of this module
    private(set) var viewportSizeBuffer: MTLBuffer!
    
    // Core Variables
    private var renderPipelineManager: RenderPipelineManager!
    private var variableTimeUpdater: CADisplayLink! // Used for Physics, Rendering, Networking, HUD and Input
    private(set) var gameBundle: Bundle!
    
    // Debugging Variables
    private var currentTimeToCalcFPS: TimeInterval = 0
    private var amountFrames: Int = 0
    open var fpsLabel: UILabel?
    
    // Scene related Variables
    public var userInterfaces = [UIView]()
    public var entities = [Entity]()
    
    
    
    open func viewDidLoad(bundle: Bundle) {
        super.viewDidLoad()
        
        self.device = MTLCreateSystemDefaultDevice()
        self.gameBundle = bundle
        self.renderPipelineManager = RenderPipelineManager.getInstance(view: self.view, device: self.device)
        
        // TODO: Make change the viewport size when the screen rotates...
        
        // Calculating the current viewport size
        var viewportSize = [Float32]()
        let frame = self.view.frame
        
        viewportSize.append(Float32(frame.width))
        viewportSize.append(Float32(frame.height))
        
        self.viewportSizeBuffer = self.device.makeBuffer(bytes: viewportSize, length: viewportSize.count * MemoryLayout<Float32>.stride, options: [])
        
        // Drawing the UI
        self.atStartRenderUI()
        
        // Creating and initializing the Game's main loop
        self.variableTimeUpdater = CADisplayLink(target: self, selector: #selector(loop)) // FPS Error
        self.variableTimeUpdater.add(to: RunLoop.main, forMode: .default)
        self.variableTimeUpdater.preferredFramesPerSecond = GameController.REQUIRED_FRAMETIME
    
        
        
    }
    
    
    
    /// Renders at the start of the engine the User's Interfaces.
    open func atStartRenderUI() {
     
        let frame = self.view.frame
        
        // FPS related label
        self.fpsLabel = UILabel(frame: CGRect(x: frame.width - 128, y: frame.height - 32, width: 128, height: 32))
        self.fpsLabel?.textColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
        self.fpsLabel?.textAlignment = .center
        self.fpsLabel?.text = "FPS ?"
        self.fpsLabel?.isHidden = true
        
        self.userInterfaces.append(self.fpsLabel!) // The 1st object is always the FPS Label
        self.view.addSubview(self.fpsLabel!)
        
        // A simple test label for saying just "Game Engine Preview"
        let testLbl = UILabel(frame: CGRect(x: frame.width / 2.0 - 100, y: 48, width: 200, height: 32))
        testLbl.textColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
        testLbl.textAlignment = .center
        testLbl.text = "Game Engine Preview"

        self.userInterfaces.append(testLbl)
        self.view.addSubview(testLbl)
        
    }

    
    
    /// Main Game Loop.
    @objc private func loop() {

        // Calculating the Delta Time from between Frames
        let deltaTime = self.variableTimeUpdater.targetTimestamp - self.variableTimeUpdater.timestamp
        
        // Physics related
        self.recalculateDynamics()
        
        // Update Entities
        self.updateScene(deltaTime: deltaTime)
        
        // Rendering related
        self.prepareToRenderSprites(deltaTime: deltaTime)
        
        // Calculating the FPS
        if let fpsLabel = self.fpsLabel {
            
            if fpsLabel.isEnabled {
                self.calculateFPS(deltaTime: deltaTime)
            }
            
        }
            
    
    }
    
      
    
    /// Handles the Physics on the Entities.
    /// NOTE: This is called by default before every subsystem (e.g. update entities)!
    open func recalculateDynamics() {
        
        for entity in self.entities {
            
            // Verifying if some body is interacting with the gravity
            if entity.rigidBody != nil {
                if entity.rigidBody!.isEnabled {
                    entity.rigidBody!.fall(force: Physics.addForce(mass: 1.0, acceleration: Physics.EARTH_GRAVITY_ACCEL))
                }
            }
            
            // Verifying if some body is intercepting another one
            if entity.collider != nil {
                if entity.collider!.isEnabled {
                    
                    // TODO: Optimize the algorithm for checking if the previous nodes were checked...
                    for target in self.entities {
                        
                        if target !== entity {
                            let isCollided = entity.collider!.intercepts(target)
                            
                            if isCollided {
                                entity.onCollision(with: target)
                            }
                        }
                        
                    }
                    
                }
            }
            
        }
        
        
    }
    
    
    
    /// Handles the Entities ticks (user setted some sort of update) or removes from the memory.
    /// NOTE: This is called by default after the physics calculation!
    /// - Parameter deltaTime: The frame delta time in relation of the previous and current frame time.
    private func updateScene(deltaTime: TimeInterval) {
        
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
    
    
    
    /// Handles the draw calls related to sprites and texture based objects.
    /// NOTE: This is called by default after the physics and entities updates!
    /// - Parameter deltaTime: The frame delta time in relation of the previous and current frame time.
    private func prepareToRenderSprites(deltaTime: TimeInterval) {
        
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
                                                                      blue: 0.0,
                                                                      alpha: 1.0)
        
        

        let commandBuffer = device.makeCommandQueue()?.makeCommandBuffer()
        let currentRenderEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        

        self.renderSprites(deltaTime: deltaTime, currentRenderEncoder: currentRenderEncoder)

        
        currentRenderEncoder.endEncoding()
        commandBuffer!.present(drawable!)
        commandBuffer!.commit() // NOTE: Here is where we really draw the sprites on the GPU

    }
    
    
    
    /// Renders the sprites on the screen.
    /// - Parameters:
    ///   - deltaTime: The frame delta time in relation of the previous and current frame time.
    ///   - currentRenderEncoder: (DO NOT MODIFY) Current Render Encoder of the GPU.
    open func renderSprites(deltaTime: TimeInterval, currentRenderEncoder: MTLRenderCommandEncoder) {
        
        for entity in self.entities {
            entity.sprite?.draw(renderCommandEncoder: currentRenderEncoder, renderPipelineManager: self.renderPipelineManager)
        }
        
    }
    
    
    
    
    /// Calculates the FPS and update the display with a label about how many is being calculated.
    /// - Parameter deltaTime: The frame delta time in relation of the previous and current frame time.
    private func calculateFPS(deltaTime: TimeInterval) {
        
        self.amountFrames += 1
        self.currentTimeToCalcFPS += deltaTime
        
        if self.currentTimeToCalcFPS >= 1.0 {
            self.fpsLabel?.text = "FPS: \(self.amountFrames)"
            
            self.amountFrames = 0
            self.currentTimeToCalcFPS = 0.0
        }
        
    }
    
    
    
    /// Adds a new entity into the current scene.
    /// - Parameter entity: A desired entity or inherited class instance that derives from entity to be added
    public func addEntity(_ entity: Entity) {
        self.entities.append(entity)
    }
    
    
    
    
    /// Resets the game.
    /// WARNING! This function must be override with your necessity  for memory management.
    open func reset() {
        
        fatalError("Error! Do not use the default reset(), please override it!")
        
    }
    
    
    
    
    
    
    
    
    // --------------------------- //
    // IOS RELATED FUNCTIONS BELOW //
    // --------------------------- //
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }
    
    override open var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
}
