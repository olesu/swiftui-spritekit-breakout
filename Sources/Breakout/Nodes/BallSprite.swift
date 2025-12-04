import SpriteKit
import AppKit

internal final class BallSprite: SKSpriteNode {
    internal init(position: CGPoint) {
        let ballSize = CGSize(width: 10, height: 10)
        let texture = BallSprite.createBallTexture(size: ballSize)
        super.init(texture: texture, color: .white, size: ballSize)
        self.name = NodeNames.ball.rawValue
        self.position = position
        self.physicsBody = BallPhysicsBodyConfigurer(size: size).physicsBody

        // Add glow effect
        let glow = SKEffectNode()
        glow.shouldRasterize = true
        glow.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 3.0])
        let glowSprite = SKSpriteNode(texture: texture, size: ballSize)
        glowSprite.color = NSColor.yellow
        glowSprite.colorBlendFactor = 0.6
        glowSprite.alpha = 0.8
        glow.addChild(glowSprite)
        glow.zPosition = -1
        addChild(glow)
    }

    private static func createBallTexture(size: CGSize) -> SKTexture {
        let image = NSImage(size: size, flipped: false) { rect in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2

            // Create radial gradient for 3D sphere effect
            let gradient = NSGradient(colors: [
                NSColor.white,                                            // Bright center (highlight)
                NSColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1.0),   // Bright yellow
                NSColor(red: 1.0, green: 0.6, blue: 0.1, alpha: 1.0)    // Orange edge
            ])!

            let path = NSBezierPath(ovalIn: rect)
            path.addClip()

            // Offset the center slightly for highlight effect
            let highlightCenter = CGPoint(x: center.x - radius * 0.3, y: center.y + radius * 0.3)
            gradient.draw(fromCenter: highlightCenter, radius: 0, toCenter: center, radius: radius, options: [])

            return true
        }
        return SKTexture(image: image)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
