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
    
    func launch(to scene: SKScene, toward target: CGPoint) {
        // Convert ball position to scene coordinates before removing from paddle
        let ballWorldPosition = parent?.convert(position, to: scene) ?? .zero
        
        let velocity = CGVector(dx: 200, dy: 200)
        
        // Remove from paddle and add to scene
        removeFromParent()
        scene.addChild(self)
        
        position = ballWorldPosition
        
        // Add physics and initial velocity
        physicsBody?.velocity = velocity

    }
    
    private func setupPhysicsBody() {
        let physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.friction = 0
        physicsBody.restitution = 1
        physicsBody.categoryBitMask = PhysicsCategory.ball
        physicsBody.contactTestBitMask = PhysicsCategory.paddle | PhysicsCategory.brick | PhysicsCategory.wall
        physicsBody.collisionBitMask = PhysicsCategory.paddle | PhysicsCategory.brick | PhysicsCategory.wall
        physicsBody.linearDamping = 0
        physicsBody.angularDamping = 0
        
        self.physicsBody = physicsBody
        
    }
}
