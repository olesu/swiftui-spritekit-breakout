import SpriteKit

/// Represents sprite-level brick information for SpriteKit rendering.
///
/// BrickData is part of the presentation layer and uses string IDs
/// for compatibility with SpriteKit's node naming system.
internal struct BrickData {
    /// String identifier for SpriteKit node naming.
    internal let id: String
    internal let position: CGPoint
    internal let color: NSColor

    internal init(id: String, position: CGPoint, color: NSColor) {
        self.id = id
        self.position = position
        self.color = color
    }
}

internal final class BrickSprite: SKSpriteNode {
    internal init(id: String, position: CGPoint, color: NSColor) {
        let brickSize = CGSize(width: 22, height: 10)
        super.init(texture: nil, color: color, size: brickSize)
        self.name = id
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
            onBrickAdded(brickData.id, brickColor)
        }
    }

}
