import SpriteKit

internal final class WallSprite: SKSpriteNode {
    internal init(position: CGPoint, size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        self.name = NodeNames.topWall.rawValue
        self.position = position
        self.physicsBody = WallPhysicsBodyConfigurer.init(size: size).physicsBody
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
