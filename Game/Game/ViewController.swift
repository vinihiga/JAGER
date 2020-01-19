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
        // Do any additional setup after loading the view.

        self.player = Player(
                        controller: self,
                        size: CGSize(width: 64, height: 64),
                        position: CGPoint(x: 0, y: 0),
                        color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0))
        
        
        self.addEntity(self.player)
        
        self.addEntity(Wall(
            controller: self,
            size: CGSize(width: 96, height: self.view.frame.size.height),
            position: CGPoint(x: self.view.frame.size.width + 48.0, y: -(self.view.frame.size.height / 2.0))))

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.player.rigidBody?.jump(force: Physics.addForce(mass: 1, acceleration: 600))
    }


}

