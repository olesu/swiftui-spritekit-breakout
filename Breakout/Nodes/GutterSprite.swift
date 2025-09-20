import SpriteKit

class GutterSprite: SKSpriteNode {
    init(position: CGPoint, size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        self.name = NodeNames.gutter.rawValue
        self.position = position
        self.physicsBody = GutterPhysicsBodyConfigurer(size: size).physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
