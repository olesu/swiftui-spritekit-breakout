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
        let texture = BrickSprite.createBrickTexture(
            size: brickSize,
            baseColor: color
        )
        super.init(texture: texture, color: .white, size: brickSize)
        self.name = id
        self.position = position
        self.physicsBody =
            BrickPhysicsBodyConfigurer(brickSize: brickSize).physicsBody
    }

    private static func createBrickTexture(size: CGSize, baseColor: NSColor)
        -> SKTexture
    {
        let image = NSImage(size: size, flipped: false) { rect in
            let path = NSBezierPath(
                roundedRect: rect.insetBy(dx: 0.5, dy: 0.5),
                xRadius: 2,
                yRadius: 2
            )

            // Lighten the base color for the top of gradient
            let lightColor =
                baseColor.blended(withFraction: 0.4, of: NSColor.white)
                ?? baseColor
            let darkColor =
                baseColor.blended(withFraction: 0.3, of: NSColor.black)
                ?? baseColor

            // Vertical gradient for 3D effect
            let gradient = NSGradient(colors: [
                lightColor, baseColor, darkColor,
            ])!
            gradient.draw(in: path, angle: 90)

            // Top highlight
            NSColor.white.withAlphaComponent(0.4).setFill()
            let highlightRect = NSRect(
                x: 2,
                y: rect.height - 3,
                width: rect.width - 4,
                height: 1.5
            )
            let highlight = NSBezierPath(
                roundedRect: highlightRect,
                xRadius: 0.5,
                yRadius: 0.5
            )
            highlight.fill()

            // Bottom shadow
            NSColor.black.withAlphaComponent(0.3).setFill()
            let shadowRect = NSRect(
                x: 2,
                y: 1,
                width: rect.width - 4,
                height: 1.5
            )
            let shadow = NSBezierPath(
                roundedRect: shadowRect,
                xRadius: 0.5,
                yRadius: 0.5
            )
            shadow.fill()

            // Border
            let borderColor =
                darkColor.blended(withFraction: 0.5, of: NSColor.black)
                ?? darkColor
            borderColor.withAlphaComponent(0.6).setStroke()
            path.lineWidth = 1
            path.stroke()

            return true
        }
        return SKTexture(image: image)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ClassicBricksLayout: SKNode {
    let brickLayout: [(BrickData, BrickColor)]

    init(
        brickSpecs: [(BrickData, BrickColor)],
        onBrickAdded: (Brick) -> Void
    ) {
        self.brickLayout = brickSpecs
        super.init()
        setupBricks(onBrickAdded: onBrickAdded)
    }

    init(
        brickSpecs: [(BrickData, BrickColor)]
    ) {
        self.brickLayout = brickSpecs
        super.init()
        setupBricks()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) var createdBricks: [Brick] = []

    private func setupBricks(onBrickAdded: (Brick) -> Void) {
        brickLayout.forEach { (brickData, brickColor) in
            let sprite = makeBrickSprite(from: brickData)
            addChild(sprite)
            
            let domainBrick = makeBrick(from: brickData, color: brickColor)
            createdBricks.append(domainBrick)
            onBrickAdded(domainBrick)
        }
    }

    private func setupBricks() {
        brickLayout.forEach { (brickData, brickColor) in
            let sprite = makeBrickSprite(from: brickData)
            addChild(sprite)
            
            let domainBrick = makeBrick(from: brickData, color: brickColor)
            createdBricks.append(domainBrick)
        }
    }

    private func makeBrickSprite(from brickData: BrickData) -> BrickSprite {
        BrickSprite(
            id: brickData.id,
            position: brickData.position,
            color: brickData.color
        )
    }

    private func makeBrick(from brickData: BrickData, color: BrickColor)
        -> Brick
    {
        Brick(
            id: BrickId(of: brickData.id),
            color: BrickColor(nsColor: brickData.color) ?? .green,
        )
    }
}
