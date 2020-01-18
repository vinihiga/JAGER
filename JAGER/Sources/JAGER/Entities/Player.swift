//
//  Material.swift
//  JAGER
//
//  Created by Vinicius Hiroshi Higa on 11/01/20.
//

import Foundation
import Metal
import MetalKit

public class Player: Entity {
    
    override public init(gameController: GameController, size: CGSize, position: CGPoint, color: SIMD4<Float>) {
        super.init(gameController: gameController, size: size, position: position, color: color)
    }
    
}
