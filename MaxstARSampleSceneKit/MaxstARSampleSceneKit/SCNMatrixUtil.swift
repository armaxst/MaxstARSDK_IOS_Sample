//
//  SCNMatrixUtil.swift
//  MaxstARSampleSceneKit
//
//  Created by Kimseunglee on 2018. 1. 24..
//  Copyright © 2018년 Maxst. All rights reserved.
//

import UIKit
import SceneKit
import simd

class SCNMatrixUtil: NSObject {
//    static func simdMatrixToSCNMatrix(matrix:simd_float4x4) -> SCNMatrix4 {
//    }
}

extension CAAnimation {
    class func animationWithSceneNamed(_ name: String) -> CAAnimation? {
        var animation: CAAnimation?
        if let scene = SCNScene(named: name) {
            scene.rootNode.enumerateChildNodes({ (child, stop) in
                if child.animationKeys.count > 0 {
                    animation = child.animation(forKey: child.animationKeys.first!)
                    print(child.animationKeys.first!)
                    stop.initialize(to: true)
                }
            })
        }
        return animation
    }
}
