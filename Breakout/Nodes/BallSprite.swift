import SpriteKit

internal final class BallSprite: SKSpriteNode {
    internal init(position: CGPoint) {
        let ballSize = CGSize(width: 8, height: 8)
        super.init(texture: nil, color: .white, size: ballSize)
        self.name = NodeNames.ball.rawValue
        self.position = position
        self.physicsBody = BallPhysicsBodyConfigurer(size: size).physicsBody
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
