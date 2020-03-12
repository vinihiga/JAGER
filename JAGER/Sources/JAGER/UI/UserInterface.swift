//
//  UserInterfacing.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 04/02/20.
//

import Foundation
import CoreGraphics

open class UserInterface: NSObject {
    
    // Default attributes
    public var size: CGSize!
    public var position: CGPoint!
    var controller: Game!
    
    // States related attributes
    var isSetToDestroy: Bool!
    
    /// Default initializer that creates an user interface on the screen.
    /// - Parameters:
    ///   - controller: The main game controller
    ///   - size: The size in relation of the screen
    ///   - position: The position in the world
    public init(controller: Game, size: CGSize, position: CGPoint) {
        
        self.controller = controller
        self.size = size
        self.position = position
        
    }
 
    
    
    /// Updates any informations as desired.
    /// - Parameter deltaTime: The time between previous and the current frame
    open func tick(deltaTime: TimeInterval) {
        // Do something here...
    }
    
    
    
    /// Sets the flag for the engine destroy this Entity in the next frame.
    public func destroy() {
        self.isSetToDestroy = true
    }
    
}
