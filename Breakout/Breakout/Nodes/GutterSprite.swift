import SpriteKit

final class GutterSprite: Sprite {
    var node: SKSpriteNode

    init(position: Point, size: Size) {
        let node = SKSpriteNode(texture: nil, color: .clear, size: CGSize(size))
        node.name = NodeNames.gutter.rawValue
        node.position = CGPoint(position)
        node.physicsBody = GutterPhysicsBodyConfigurer(size: CGSize(size)).physicsBody

        self.node = node
    }

}
