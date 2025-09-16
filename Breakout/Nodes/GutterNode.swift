import SpriteKit

class GutterNode: SKNode {
    init(position: CGPoint, size: CGSize) {
        super.init()
        let gutter = SKSpriteNode(color: .clear, size: size)
        gutter.physicsBody = SKPhysicsBody(rectangleOf: size)
        gutter.physicsBody?.isDynamic = false
        gutter.physicsBody?.categoryBitMask = 2
        gutter.position = position
        addChild(gutter)
        self.name = NodeNames.gutter.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
