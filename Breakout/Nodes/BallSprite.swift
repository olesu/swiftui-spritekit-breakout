import SpriteKit

class BallSprite: SKSpriteNode {
    init(position: CGPoint) {
        let ballSize = CGSize(width: 8, height: 8)
        super.init(texture: nil, color: .white, size: ballSize)
        self.name = NodeNames.ball.rawValue
        self.position = position

        self.physicsBody = setupPhysics(size: ballSize)
    }

    private func setupPhysics(size: CGSize) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)

        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = CollisionCategory.ball.rawValue
        physicsBody.contactTestBitMask = 1 | 2 | 8 | 16
        physicsBody.collisionBitMask = 1 | 8 | 16
        physicsBody.restitution = 1.0
        physicsBody.friction = 0
        physicsBody.linearDamping = 0
        physicsBody.angularDamping = 0
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false 
        physicsBody.velocity = CGVector(dx: 200, dy: 300)

        return physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
