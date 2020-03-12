//
//  Scene.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 04/02/20.
//

import Foundation

open class Scene: NSObject {
    
    // Default attributes
    public var userInterfaces: [UserInterface]
    public var entities: [Entity]
    public var resetExtension: (()->Void)? // This is an extension for the reset function
    
    
    /// Default Initializer where instantiates a empty Scene with a custom reset function.
    /// - Parameter resetExtension: A closure that must be pass as an extension for the function self.reset()
    public init(resetExtension: @escaping ()->Void) {
        
        self.userInterfaces = [UserInterface]()
        self.entities = [Entity]()
        self.resetExtension = resetExtension
        
        super.init()
    }
    
    
    
    /// Handles the Entities ticks (user setted some sort of update) or removes from the memory.
    /// NOTE: This is called by default after the physics calculation!
    /// - Parameter deltaTime: The frame delta time in relation of the previous and current frame time.
    public func updateScene(deltaTime: TimeInterval) {
        
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
        
        currentIndex = 0
        
        while currentIndex < self.userInterfaces.count {
            if self.userInterfaces[currentIndex].isSetToDestroy {
                self.userInterfaces.remove(at: currentIndex)
            }
            else {
                self.userInterfaces[currentIndex].tick(deltaTime: deltaTime)
                currentIndex += 1
            }
        }

    }
    
    
    
    /// Resets the scene by handling the game state as needs.
    /// TIPS: You can either override this function with custom settings or you must pass a function to the resetExtension attribute to be executed.
    public func reset() {
        
        // If this function is not overrided and not called...
        // We don't need that extension below to be executed!
        if self.resetExtension != nil {
            self.resetExtension!()
        }
        
    }
    
}
