//
//  BottomWallController.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 13/09/2025.
//

import Foundation
import SpriteKit

class BottomWallController: SKNode {
    init (worldSize: CGSize) {
        super.init()
        
        position = CGPoint(x: worldSize.width / 2, y: 0)
        physicsBody = SKPhysicsBody(
            edgeLoopFrom: CGRect(
                origin: .zero,
                size: CGSize(width: worldSize.width, height: 0)
            )
        )
        physicsBody?.categoryBitMask = PhysicsCategory.bottomWall
        physicsBody?.contactTestBitMask = PhysicsCategory.ball
        physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
