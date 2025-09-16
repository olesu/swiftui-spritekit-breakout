import SpriteKit

class PaddleSprite: SKSpriteNode {
    init(position: CGPoint) {
        let paddleSize = CGSize(width: 60, height: 12)
        super.init(texture: nil, color: .white, size: paddleSize)
        self.name = NodeNames.paddle.rawValue
        self.position = position
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: paddleSize)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = 16
        self.physicsBody?.contactTestBitMask = 4
        self.physicsBody?.collisionBitMask = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

