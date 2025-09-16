import SpriteKit

class WallNode: SKNode {
    init(position: CGPoint, size: CGSize) {
        super.init()
        let wall = SKSpriteNode(color: .clear, size: size)
        wall.physicsBody = SKPhysicsBody(rectangleOf: size)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = 1
        wall.position = position
        addChild(wall)
        self.name = NodeNames.topWall.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
