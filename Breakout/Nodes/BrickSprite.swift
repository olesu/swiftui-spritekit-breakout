import SpriteKit

struct BrickData {
    let position: CGPoint
    let color: NSColor
}

class BrickSprite: SKSpriteNode {
    init(position: CGPoint, color: NSColor) {
        let brickSize = CGSize(width: 22, height: 10)
        super.init(texture: nil, color: color, size: brickSize)
        self.position = position
        self.physicsBody = setupPhysics(brickSize: brickSize)
    }
    
    func setupPhysics(brickSize: CGSize) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = CollisionCategory.brick.mask
        physicsBody.contactTestBitMask = CollisionCategory.ball.mask
        return physicsBody
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ClassicBricksLayout: SKNode {
    let brickLayout: [BrickData] = [
        // Red row (top)
        BrickData(position: CGPoint(x: 11, y: 420), color: .red),
        BrickData(position: CGPoint(x: 34, y: 420), color: .red),
        BrickData(position: CGPoint(x: 57, y: 420), color: .red),
        BrickData(position: CGPoint(x: 80, y: 420), color: .red),
        BrickData(position: CGPoint(x: 103, y: 420), color: .red),
        BrickData(position: CGPoint(x: 126, y: 420), color: .red),
        BrickData(position: CGPoint(x: 149, y: 420), color: .red),
        BrickData(position: CGPoint(x: 172, y: 420), color: .red),
        BrickData(position: CGPoint(x: 195, y: 420), color: .red),
        BrickData(position: CGPoint(x: 218, y: 420), color: .red),
        BrickData(position: CGPoint(x: 241, y: 420), color: .red),
        BrickData(position: CGPoint(x: 264, y: 420), color: .red),
        BrickData(position: CGPoint(x: 287, y: 420), color: .red),
        BrickData(position: CGPoint(x: 310, y: 420), color: .red),
        // Red row 2
        BrickData(position: CGPoint(x: 11, y: 408), color: .red),
        BrickData(position: CGPoint(x: 34, y: 408), color: .red),
        BrickData(position: CGPoint(x: 57, y: 408), color: .red),
        BrickData(position: CGPoint(x: 80, y: 408), color: .red),
        BrickData(position: CGPoint(x: 103, y: 408), color: .red),
        BrickData(position: CGPoint(x: 126, y: 408), color: .red),
        BrickData(position: CGPoint(x: 149, y: 408), color: .red),
        BrickData(position: CGPoint(x: 172, y: 408), color: .red),
        BrickData(position: CGPoint(x: 195, y: 408), color: .red),
        BrickData(position: CGPoint(x: 218, y: 408), color: .red),
        BrickData(position: CGPoint(x: 241, y: 408), color: .red),
        BrickData(position: CGPoint(x: 264, y: 408), color: .red),
        BrickData(position: CGPoint(x: 287, y: 408), color: .red),
        BrickData(position: CGPoint(x: 310, y: 408), color: .red),
        // Orange row
        BrickData(position: CGPoint(x: 11, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 34, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 57, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 80, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 103, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 126, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 149, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 172, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 195, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 218, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 241, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 264, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 287, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 310, y: 396), color: .orange),
        // Orange row 2
        BrickData(position: CGPoint(x: 11, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 34, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 57, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 80, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 103, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 126, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 149, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 172, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 195, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 218, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 241, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 264, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 287, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 310, y: 384), color: .orange),
        // Yellow row
        BrickData(position: CGPoint(x: 11, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 34, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 57, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 80, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 103, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 126, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 149, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 172, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 195, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 218, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 241, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 264, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 287, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 310, y: 372), color: .yellow),
        // Yellow row 2
        BrickData(position: CGPoint(x: 11, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 34, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 57, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 80, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 103, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 126, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 149, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 172, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 195, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 218, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 241, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 264, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 287, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 310, y: 360), color: .yellow),
        // Green row
        BrickData(position: CGPoint(x: 11, y: 348), color: .green),
        BrickData(position: CGPoint(x: 34, y: 348), color: .green),
        BrickData(position: CGPoint(x: 57, y: 348), color: .green),
        BrickData(position: CGPoint(x: 80, y: 348), color: .green),
        BrickData(position: CGPoint(x: 103, y: 348), color: .green),
        BrickData(position: CGPoint(x: 126, y: 348), color: .green),
        BrickData(position: CGPoint(x: 149, y: 348), color: .green),
        BrickData(position: CGPoint(x: 172, y: 348), color: .green),
        BrickData(position: CGPoint(x: 195, y: 348), color: .green),
        BrickData(position: CGPoint(x: 218, y: 348), color: .green),
        BrickData(position: CGPoint(x: 241, y: 348), color: .green),
        BrickData(position: CGPoint(x: 264, y: 348), color: .green),
        BrickData(position: CGPoint(x: 287, y: 348), color: .green),
        BrickData(position: CGPoint(x: 310, y: 348), color: .green),
        // Green row 2
        BrickData(position: CGPoint(x: 11, y: 336), color: .green),
        BrickData(position: CGPoint(x: 34, y: 336), color: .green),
        BrickData(position: CGPoint(x: 57, y: 336), color: .green),
        BrickData(position: CGPoint(x: 80, y: 336), color: .green),
        BrickData(position: CGPoint(x: 103, y: 336), color: .green),
        BrickData(position: CGPoint(x: 126, y: 336), color: .green),
        BrickData(position: CGPoint(x: 149, y: 336), color: .green),
        BrickData(position: CGPoint(x: 172, y: 336), color: .green),
        BrickData(position: CGPoint(x: 195, y: 336), color: .green),
        BrickData(position: CGPoint(x: 218, y: 336), color: .green),
        BrickData(position: CGPoint(x: 241, y: 336), color: .green),
        BrickData(position: CGPoint(x: 264, y: 336), color: .green),
        BrickData(position: CGPoint(x: 287, y: 336), color: .green),
        BrickData(position: CGPoint(x: 310, y: 336), color: .green)
    ]
    
    override init() {
        super.init()
        setupBricks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBricks() {
        brickLayout.forEach { brickData in
            let brick = BrickSprite(position: brickData.position, color: brickData.color)
            addChild(brick)
        }
    }
}
