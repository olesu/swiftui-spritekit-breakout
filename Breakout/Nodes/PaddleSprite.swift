import SpriteKit

class PaddleSprite: SKSpriteNode {
    init(position: CGPoint) {
        let paddleSize = CGSize(width: 60, height: 12)
        super.init(texture: nil, color: .white, size: paddleSize)
        self.name = NodeNames.paddle.rawValue
        self.position = position
        self.physicsBody = setupPhysics(paddleSize: paddleSize)
    }

    func setupPhysics(paddleSize: CGSize) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: paddleSize)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = CollisionCategory.paddle.mask
        physicsBody.contactTestBitMask = CollisionCategory.ball.mask
        physicsBody.collisionBitMask = CollisionCategory.ball.mask
        return physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

