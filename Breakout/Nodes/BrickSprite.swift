import SpriteKit

internal struct BrickData {
    internal let id: UUID = UUID()
    internal let position: CGPoint
    internal let color: NSColor
}

internal final class BrickSprite: SKSpriteNode {
    internal init(id: UUID, position: CGPoint, color: NSColor) {
        let brickSize = CGSize(width: 22, height: 10)
        super.init(texture: nil, color: color, size: brickSize)
        self.name = id.uuidString
        self.position = position
        self.physicsBody = BrickPhysicsBodyConfigurer(brickSize: brickSize).physicsBody
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal final class ClassicBricksLayout: SKNode {
    internal let brickLayout: [(BrickData, BrickColor)]

    internal init(bricks: [(BrickData, BrickColor)], onBrickAdded: (String, BrickColor) -> ()) {
        self.brickLayout = bricks
        super.init()
        setupBricks(onBrickAdded: onBrickAdded)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBricks(onBrickAdded: (String, BrickColor) -> ()) {
        brickLayout.forEach { (brickData, brickColor) in
            let brick = BrickSprite(
                id: brickData.id,
                position: brickData.position,
                color: brickData.color
            )
            addChild(brick)
            onBrickAdded(brickData.id.uuidString, brickColor)
        }
    }

}
