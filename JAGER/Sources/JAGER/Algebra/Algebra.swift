//
//  File.swift
//  
//
//  Created by Vinicius Hiroshi Higa on 13/03/20.
//

import Foundation
import CoreGraphics

open class Algebra {
    
    public static func distance(from a: CGPoint, to b: CGPoint) -> CGFloat {
        return CGFloat(sqrt(pow(a.x - b.x, 2.0) + pow(a.y - b.y, 2.0)))
    }
    
}
