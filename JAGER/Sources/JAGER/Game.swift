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

open class Game: UIViewController {
    
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
    open var fpsLabel: GUIText?
    private var previousFrameTime: Double = 0
    
    open var isPhysicsEnabled: Bool = true
    
    // Scene related Variables
    private var currentScene: Scene?
    private var nextScene: Scene?
    
    
    
    open func viewDidLoad(bundle: Bundle, scene: Scene) {
        super.viewDidLoad()
        
        self.device = MTLCreateSystemDefaultDevice()
        self.gameBundle = bundle
        self.currentScene = scene
        self.renderPipelineManager = RenderPipelineManager.getInstance(controller: self, device: self.device)
        
        // TODO: Make change the viewport size when the screen rotates...
        
        // Calculating the current viewport size
        var viewportSize = [Float32]()
        let frame = self.view.frame
        
        viewportSize.append(Float32(frame.width))
        viewportSize.append(Float32(frame.height))
        
        self.viewportSizeBuffer = self.device.makeBuffer(bytes: viewportSize, length: viewportSize.count * MemoryLayout<Float32>.stride, options: [])
        
        
        // Instantiating the Fps Label
        self.fpsLabel = GUIText(
            controller: self,
            size: CGSize(width: 200, height: 32),
            position: CGPoint(x: frame.width / 2.0 - 100, y: 48),
            text: "FPS: ?",
            color: UIColor.init(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0))
            
        
        // Creating and initializing the Game's main loop
        self.variableTimeUpdater = CADisplayLink(target: self, selector: #selector(loop)) // FPS Error
        self.variableTimeUpdater.add(to: RunLoop.main, forMode: .default)
        self.variableTimeUpdater.preferredFramesPerSecond = Game.REQUIRED_FRAMETIME
        
    
    }
    
    
    
    /// Main Game Loop.
    @objc private func loop() {

        if self.nextScene != nil {
            self.currentScene = self.nextScene
            self.nextScene = nil
        }
        
        // Calculating the Delta Time between Previous Frame and the Actual Frame
        let deltaTime = self.variableTimeUpdater.timestamp - self.previousFrameTime
        self.previousFrameTime = self.variableTimeUpdater.timestamp

        // Physics related
        if self.isPhysicsEnabled && self.currentScene != nil {
            Physics.calculateDynamics(entities: self.currentScene!.entities)
        }
        
        // Update Entities
        if self.currentScene != nil {
            self.currentScene!.updateScene(deltaTime: deltaTime)
        }
        
        // Rendering related
        if self.currentScene != nil {
            self.renderPipelineManager!.renderSprites(scene: self.currentScene!)
        }
        
        // Calculating the FPS
        if let fpsLabel = self.fpsLabel {
            
            if fpsLabel.isEnabled {
                self.calculateFPS(deltaTime: deltaTime)
            }
            
        }
            
    }
    

    
    /// Calculates the FPS and update the display with a label about how many is being calculated.
    /// - Parameter deltaTime: The frame delta time in relation of the previous and current frame time.
    private func calculateFPS(deltaTime: TimeInterval) {
        
        // Checking if the Fps Label was registered inside the User Interface List...
        let isAlreadyRegistered = self.currentScene!.userInterfaces.contains(self.fpsLabel!)
        
        if !isAlreadyRegistered {
            self.view.addSubview(self.fpsLabel!.label)
            self.currentScene?.userInterfaces.append(self.fpsLabel!)
        }
        
        // Calculating the amount of Frames per Second
        if self.previousFrameTime > 0 {
            let actualFps = 1 / deltaTime
            self.fpsLabel?.text = "FPS: \(Int(actualFps))"
        }
        
    }
    
    
    
    /// Adds a new entity into the current scene.
    /// - Parameter entity: A desired entity or inherited class instance that derives from entity to be added
    public func addEntity(_ entity: Entity) {
        self.currentScene?.entities.append(entity)
    }
    
    
    
    /// Gets the current scene.
    public func getCurrentScene() throws -> Scene {
        
        if self.currentScene == nil {
            throw GameError.sceneNotLoaded
        }
        
        return self.currentScene!
    }
    
    
    
    /// Sets the next scene.
    /// The next scene will be loaded when the current frame is over.
    /// - Parameter scene: An instance of the next scene
    public func setNextScene(_ scene: Scene) {
        self.nextScene = scene
    }
    
    
    
    
    
    
    
    
    // --------------------------- //
    // IOS RELATED FUNCTIONS BELOW //
    // --------------------------- //
    
    override open func viewDidLoad() {
        fatalError("Error! Do not use this viewDidLoad(), instead use viewDidLoad(bundle:) for the game!")
    }
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }
    
    override open var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
}
