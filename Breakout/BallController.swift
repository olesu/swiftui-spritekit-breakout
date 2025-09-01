//
//  BallController.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 31/08/2025.
//

import SpriteKit

class BallController: SKSpriteNode {
    init(paddlePosition: CGPoint) {
        let ballSize = CGSize(width: 12, height: 12)
        let ballPosition = CGPoint(
            x: paddlePosition.x,
            y: paddlePosition.y + 20
        )
        
        super.init(texture: nil, color: .white, size: ballSize)
        
        self.position = ballPosition
        
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        let physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.friction = 0
        physicsBody.restitution = 1
        physicsBody.categoryBitMask = PhysicsCategory.ball
        physicsBody.contactTestBitMask = PhysicsCategory.paddle | PhysicsCategory.brick
        physicsBody.collisionBitMask = PhysicsCategory.paddle | PhysicsCategory.brick
        
        self.physicsBody = physicsBody
        
    }
}
