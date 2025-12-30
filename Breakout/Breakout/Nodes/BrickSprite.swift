import SpriteKit

final class BrickSprite: Sprite {
    var node: SKSpriteNode
    
    init(brickData: BrickData) {
        // TODO: Should not be hardcoded here
        let brickSize = CGSize(width: 22, height: 10)
        let texture = BrickSprite.createBrickTexture(
            size: brickSize,
            baseColor: brickData.color.toNSColor()
        )
        self.node = SKSpriteNode(texture: texture, color: .white, size: brickSize)
        node.name = brickData.id
        node.position = brickData.cgPosition
        node.physicsBody =
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

