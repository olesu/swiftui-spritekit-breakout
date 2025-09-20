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
        physicsBody.categoryBitMask = 16
        physicsBody.contactTestBitMask = 4
        physicsBody.collisionBitMask = 4
        return physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

