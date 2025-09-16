import Foundation
import SpriteKit

class PaddleController: SKSpriteNode {
    private var paddle: Paddle
    
    init(gameAreaWidth: CGFloat) {
        // Initialize the paddle model with the game area constraints
        self.paddle = Paddle(
            position: CGPoint(x: gameAreaWidth / 2, y: 50),
            size: CGSize(width: 80, height: 16),
            minX: 40, // half paddle width
            maxX: gameAreaWidth - 40 // game width - half paddle width
        )
        
        super.init(
            texture: nil,
            color: .white,
            size: paddle.size
        )
        
        // Set the visual position
        self.position = paddle.position
        
        // Set up physics body
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysicsBody() {
        // Create rectangular physics body matching the paddle size
        let physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        
        // Configure physics properties
        physicsBody.isDynamic = false // Static body - won't be affected by forces
        physicsBody.affectedByGravity = false // No gravity effects
        physicsBody.friction = 0 // No friction for clean bounces
        physicsBody.restitution = 1.0 // Perfect bounce (no energy loss)
        
        // Set physics categories for collision detection
        physicsBody.categoryBitMask = PhysicsCategory.paddle
        physicsBody.contactTestBitMask = PhysicsCategory.ball
        physicsBody.collisionBitMask = PhysicsCategory.ball
        
        // Assign the physics body to this node
        self.physicsBody = physicsBody
    }
    
    func moveTo(x: CGFloat) {
        paddle.move(to: x)
        self.position = paddle.position
    }
    
    var paddleFrame: CGRect {
        return CGRect(
            x: position.x - size.width / 2,
            y: position.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }
}
