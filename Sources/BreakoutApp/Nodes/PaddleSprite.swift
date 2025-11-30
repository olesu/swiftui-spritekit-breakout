import SpriteKit
import AppKit

internal final class PaddleSprite: SKSpriteNode {
    internal init(position: CGPoint) {
        let paddleSize = CGSize(width: 60, height: 12)
        let texture = PaddleSprite.createPaddleTexture(size: paddleSize)
        super.init(texture: texture, color: .white, size: paddleSize)
        self.name = NodeNames.paddle.rawValue
        self.position = position
        self.physicsBody = PaddlePhysicsBodyConfigurer(paddleSize: paddleSize).physicsBody

        // Add glow effect
        let glow = SKEffectNode()
        glow.shouldRasterize = true
        glow.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 4.0])
        let glowSprite = SKSpriteNode(texture: texture, size: paddleSize)
        glowSprite.color = NSColor.cyan
        glowSprite.colorBlendFactor = 0.8
        glowSprite.alpha = 0.6
        glow.addChild(glowSprite)
        glow.zPosition = -1
        addChild(glow)
    }

    private static func createPaddleTexture(size: CGSize) -> SKTexture {
        let image = NSImage(size: size, flipped: false) { rect in
            let path = NSBezierPath(roundedRect: rect, xRadius: 4, yRadius: 4)

            // Gradient fill
            let gradient = NSGradient(colors: [
                NSColor(red: 0.2, green: 0.7, blue: 1.0, alpha: 1.0),  // Bright cyan
                NSColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0)   // Darker blue
            ])!
            gradient.draw(in: path, angle: 90)

            // Top highlight
            NSColor.white.withAlphaComponent(0.3).setFill()
            let highlight = NSBezierPath(roundedRect: NSRect(x: 2, y: rect.height - 4, width: rect.width - 4, height: 2), xRadius: 1, yRadius: 1)
            highlight.fill()

            // Border
            NSColor.white.withAlphaComponent(0.5).setStroke()
            path.lineWidth = 1.5
            path.stroke()

            return true
        }
        return SKTexture(image: image)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

