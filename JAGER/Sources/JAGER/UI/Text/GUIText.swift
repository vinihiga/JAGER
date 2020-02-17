//
//  Text.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 04/02/20.
//

import Foundation
import UIKit
import CoreGraphics
import MetalKit

open class GUIText: UserInterface {
 
    // Default attributes
    public var text: String { get { return self.label.text ?? "" } set { self.label.text = newValue } }
    public var isHidden: Bool { get { return self.label.isHidden } set { self.label.isHidden = newValue } }
    public var isEnabled: Bool { get { return self.label.isEnabled } set { self.label.isEnabled = newValue }}
    public var label: UILabel!
    

    /// Required default initializer that creates a text.
    /// - Parameters:
    ///   - controller: The main game controller
    ///   - size: The size in relation of the screen
    ///   - position: The position in the world
    public override init(controller: GameController, size: CGSize, position: CGPoint) {
        super.init(controller: controller, size: size, position: position)
        
        self.label = UILabel(frame: CGRect(x: position.x, y: position.y, width: size.width, height: size.height))
        self.label.text = ""
        self.label.textAlignment = .center
        
        self.isSetToDestroy = false
        
    }
    
    
    
    /// Optional initializer that creates a text.
    /// - Parameters:
    ///   - controller: The main game controller
    ///   - size: The size in relation of the screen
    ///   - position: The position in the world
    ///   - text: The text / content
    public init(controller: GameController, size: CGSize, position: CGPoint, text: String) {
        super.init(controller: controller, size: size, position: position)
        
        self.label = UILabel(frame: CGRect(x: position.x, y: position.y, width: size.width, height: size.height))
        self.label.text = text
        self.label.textAlignment = .center
        
        self.isSetToDestroy = false
        
    }
    
    
    
    /// Optional initializer that creates a text with certain color.
    /// - Parameters:
    ///   - controller: The main game controller
    ///   - size: The size in relation of the screen
    ///   - position: The position in the world
    ///   - text: The text / content
    ///   - color: The color of the text
    public init(controller: GameController, size: CGSize, position: CGPoint, text: String, color: UIColor) {
        super.init(controller: controller, size: size, position: position)
        
        self.label = UILabel(frame: CGRect(x: position.x, y: position.y, width: size.width, height: size.height))
        self.label.text = text
        self.label.textAlignment = .center
        self.label.textColor = color
        
        self.isSetToDestroy = false
        
    }
    
    
    
    /// Updates any informations as desired.
    /// - Parameter deltaTime: The time between previous and the current frame
    open override func tick(deltaTime: TimeInterval) {
        // Do something here...
    }
    
    
    
    /// Sets the flag for the engine destroy this Entity in the next frame.
    public override func destroy() {
        self.isSetToDestroy = true
    }

}
