import AppKit
import SpriteKit

final class PaddleSprite: Sprite {
    var node: SKSpriteNode

    init(position: Point, size: Size) {
        let texture = PaddleSprite.createPaddleTexture(size: CGSize(size))
        let node = SKSpriteNode(
            texture: texture,
            color: .white,
            size: CGSize(size)
        )
        node.name = NodeNames.paddle.rawValue
        node.position = CGPoint(position)
        node.physicsBody =
            PaddlePhysicsBodyConfigurer(paddleSize: CGSize(size)).physicsBody

        // Add glow effect
        let glow = SKEffectNode()
        glow.shouldRasterize = true
        glow.filter = CIFilter(
            name: "CIGaussianBlur",
            parameters: ["inputRadius": 4.0]
        )
        let glowSprite = SKSpriteNode(texture: texture, size: CGSize(size))
        glowSprite.color = NSColor.cyan
        glowSprite.colorBlendFactor = 0.8
        glowSprite.alpha = 0.6
        glow.addChild(glowSprite)
        glow.zPosition = -1
        node.addChild(glow)

        self.node = node
    }

    private static func createPaddleTexture(size: CGSize) -> SKTexture {
        let image = NSImage(size: size, flipped: false) { rect in
            let path = NSBezierPath(roundedRect: rect, xRadius: 4, yRadius: 4)

            // Gradient fill
            let gradient = NSGradient(colors: [
                NSColor(red: 0.2, green: 0.7, blue: 1.0, alpha: 1.0),  // Bright cyan
                NSColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0),  // Darker blue
            ])!
            gradient.draw(in: path, angle: 90)

            // Top highlight
            NSColor.white.withAlphaComponent(0.3).setFill()
            let highlight = NSBezierPath(
                roundedRect: NSRect(
                    x: 2,
                    y: rect.height - 4,
                    width: rect.width - 4,
                    height: 2
                ),
                xRadius: 1,
                yRadius: 1
            )
            highlight.fill()

            // Border
            NSColor.white.withAlphaComponent(0.5).setStroke()
            path.lineWidth = 1.5
            path.stroke()

            return true
        }
        return SKTexture(image: image)
    }

}
