import SpriteKit

struct BrickData {
    let id: UUID = UUID()
    let position: CGPoint
    let color: NSColor
}

class BrickSprite: SKSpriteNode {
    init(id: UUID, position: CGPoint, color: NSColor) {
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

class ClassicBricksLayout: SKNode {
    let brickLayout: [BrickData]

    init(bricks: [BrickData], onBrickAdded: (String, NSColor) -> ()) {
        self.brickLayout = bricks
        super.init()
        setupBricks(onBrickAdded: onBrickAdded)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBricks(onBrickAdded: (String, NSColor) -> ()) {
        brickLayout.forEach { brickData in
            let brick = BrickSprite(
                id: brickData.id,
                position: brickData.position,
                color: brickData.color
            )
            addChild(brick)
            onBrickAdded(brickData.id.uuidString, brickData.color)
        }
    }
    
}
