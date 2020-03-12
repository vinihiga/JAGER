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
    

    /// Prepares the Main Game Loop with the Game's Objects.
    override func viewDidLoad() {
        super.viewDidLoad(bundle: Bundle.main, scene: Scene(resetExtension: self.resetExtension))
        
        // Creating a Character for the Player
        self.player = Player(
                        controller: self,
                        size: CGSize(width: 64, height: 64),
                        position: CGPoint(x: 0, y: 0))
        

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
            
            
            // Creating the ground and roof
            let size = self.view.frame.size
            self.addEntity(Ground(controller: self, size: CGSize(width: size.height, height: 64.0), position: CGPoint(x: 0, y: size.height - 32.0)))
            self.addEntity(Ground(controller: self, size: CGSize(width: size.height, height: 64.0), position: CGPoint(x: 0, y: -size.height + 32.0)))

            // Creating the Spawner Handler for the Walls
            self.addEntity(Spawner.getInstance(controller: self, position: CGPoint.zero, spawnTime: 3.0))
        }
        catch {}

    }
    
    
    
    /// Handles the input on touch.
    /// NOTE: This Function do not track "Long Press" touches.
    /// - Parameters:
    ///   - touches: A "list" of UITouchs
    ///   - event: The event related with the Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.player.rigidBody?.jump(force: Physics.addForce(mass: 1, acceleration: 550))
    }

}

