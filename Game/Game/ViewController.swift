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

class ViewController: GameController  {

    private var player: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad(bundle: Bundle.main)
        
        // Creating a Character for the Player
        self.player = Player(
                        controller: self,
                        size: CGSize(width: 64, height: 64),
                        position: CGPoint(x: 0, y: 0),
                        color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0))
        
        
        self.addEntity(self.player)
        
        
        
        // Creating the Spawner Handler for the Walls
        self.addEntity(Spawner.getInstance(controller: self, position: CGPoint.zero, spawnTime: 2.0))

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.player.rigidBody?.jump(force: Physics.addForce(mass: 1, acceleration: 600))
    }


}

