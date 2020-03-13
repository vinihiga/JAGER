//
//  ViewController.swift
//  Game
//
//  Created by Vinicius Hiroshi Higa on 10/01/20.
//  Copyright © 2020 Vini Games. All rights reserved.
//

import UIKit
import Metal
import JAGER

class ViewController: Game  {

    // Games Objects and Properties
    private var player: Player!
    private var lightEmitter: Entity!
    

    /// Prepares the Main Game Loop with the Game's Objects.
    override func viewDidLoad() {
        super.viewDidLoad(bundle: Bundle.main, scene: Scene(resetExtension: self.resetExtension))
        
        // Creating a Character for the Player
        self.player = Player(
                        controller: self,
                        size: CGSize(width: 96, height: 96),
                        position: CGPoint(x: 0, y: 0))
        

        // Creating a Light Emitter for Material Testing...
        self.lightEmitter = Entity(controller: self,
                                   name: "Light Emitter",
                                   size: CGSize(width: 48, height: 48),
                                   position: CGPoint(x: 256, y: 0),
                                   color: SIMD3<Float>(1.0, 1.0, 1.0))
        
        
        
        do {
            try self.getCurrentScene().reset()
        }
        catch {}
        
        self.fpsLabel?.isHidden = false

    }
    

    
    /// Auxiliary function that extends the functionality of the main scene to reset the current game state.
    /// NOTE: You can create any amount of extensions for the reset function, but in this example we
    /// consider there is only one scene or a.k.a "Main Scene".
    func resetExtension() {
        
        do {
            // Removing all previous entities
            try self.getCurrentScene().entities.removeAll()
            
            // Creating a Character for the Player
            self.player.position = CGPoint.zero
            self.player.rigidBody?.reset()
            self.addEntity(self.player)
            
            // Adding the Light Emitter
            self.addEntity(self.lightEmitter)

        }
        catch {}

    }
    
    
    
    /// Handles the input on touch.
    /// NOTE: This Function do not track "Long Press" touches.
    /// - Parameters:
    ///   - touches: A "list" of UITouchs
    ///   - event: The event related with the Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }

}

