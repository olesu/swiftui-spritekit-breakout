import SpriteKit

internal final class PaddleSprite: SKSpriteNode {
    internal init(position: CGPoint) {
        let paddleSize = CGSize(width: 60, height: 12)
        super.init(texture: nil, color: .white, size: paddleSize)
        self.name = NodeNames.paddle.rawValue
        self.position = position
        self.physicsBody = PaddlePhysicsBodyConfigurer(paddleSize: paddleSize).physicsBody
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

