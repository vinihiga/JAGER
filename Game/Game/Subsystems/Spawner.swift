//
//  Spawner.swift
//  Game
//
//  Created by Vinicius Hiroshi Higa on 19/01/20.
//  Copyright © 2020 Vini Games. All rights reserved.
//

import Foundation
import CoreGraphics
import JAGER

class Spawner: Entity {
 
    private var currentTimeElapsed: TimeInterval!
    private var spawnTime: TimeInterval!
    
    private static var instance: Spawner?
    
    
    private init(controller: GameController, position: CGPoint, spawnTime: TimeInterval) {
        super.init(controller: controller, position: position)
        
        self.currentTimeElapsed = 0.0
        self.spawnTime = spawnTime
        
    }
    
    
    
    override func tick(deltaTime: TimeInterval) {
        
        self.currentTimeElapsed += deltaTime
        
        if currentTimeElapsed >= self.spawnTime {
            
            let isBottomTime = Bool.random()

            if isBottomTime {

                self.controller.addEntity(Wall(
                    controller: self.controller,
                    size: CGSize(width: 96, height: self.controller.view.frame.size.height),
                    position: CGPoint(x: self.controller.view.frame.size.width + 48.0, y: self.controller.view.frame.size.height / 2.0)))

                self.controller.addEntity(Wall(
                    controller: self.controller,
                    size: CGSize(width: 96, height: self.controller.view.frame.size.height),
                    position: CGPoint(x: self.controller.view.frame.size.width + 48.0, y: -(self.controller.view.frame.size.height / 2.0) - 512.0)))

            }
            else {

                self.controller.addEntity(Wall(
                    controller: self.controller,
                    size: CGSize(width: 96, height: self.controller.view.frame.size.height),
                    position: CGPoint(x: self.controller.view.frame.size.width + 48.0, y: self.controller.view.frame.size.height / 2.0 +  512.0)))

                self.controller.addEntity(Wall(
                    controller: self.controller,
                    size: CGSize(width: 96, height: self.controller.view.frame.size.height),
                    position: CGPoint(x: self.controller.view.frame.size.width + 48.0, y: -(self.controller.view.frame.size.height / 2.0))))

            }
            
            self.currentTimeElapsed = 0.0
            
        }
        
    }
    
    
    
    static public func getInstance(controller: GameController, position: CGPoint, spawnTime: TimeInterval) -> Spawner {
        
        if Spawner.instance == nil {
            Spawner.instance = Spawner(controller: controller, position: position, spawnTime: spawnTime)
        }
        
        return Spawner.instance!
        
    }
    
}
