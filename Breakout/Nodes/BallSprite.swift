import SpriteKit

class BallSprite: SKSpriteNode {
    init(position: CGPoint) {
        let ballSize = CGSize(width: 8, height: 8)
        super.init(texture: nil, color: .white, size: ballSize)
        self.name = NodeNames.ball.rawValue
        self.position = position
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: ballSize)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = 4
        self.physicsBody?.contactTestBitMask = 1 | 2 | 8 | 16
        self.physicsBody?.collisionBitMask = 1 | 8 | 16
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.affectedByGravity = false
        
        // Set initial velocity (diagonal up and right)
        self.physicsBody?.velocity = CGVector(dx: 200, dy: 300)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

