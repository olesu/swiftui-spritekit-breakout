import SpriteKit
import AppKit

final class SKBallSprite: Sprite {
    var node: SKSpriteNode

    private let disabledMask: UInt32 = 0x0

    init(position: Point) {
        let ballSize = CGSize(width: 10, height: 10)
        let texture = SKBallSprite.createBallTexture(size: ballSize)

        self.node = SKSpriteNode(texture: texture, color: .white, size: ballSize)
        node.name = NodeNames.ball.rawValue
        node.position = CGPoint(position)
        node.physicsBody = BallPhysicsBodyConfigurer(size: ballSize).physicsBody
        node.addChild(makeGlowEffect(texture: texture, size: ballSize))
    }

}

extension SKBallSprite {
    private func makeGlowEffect(texture: SKTexture, size: CGSize) -> SKEffectNode {
        let glow = SKEffectNode()
        glow.shouldRasterize = true
        glow.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 3.0])
        let glowSprite = SKSpriteNode(texture: texture, size: size)
        glowSprite.color = NSColor.yellow
        glowSprite.colorBlendFactor = 0.6
        glowSprite.alpha = 0.8
        glow.addChild(glowSprite)
        glow.zPosition = -1

        return glow
    }
}

extension SKBallSprite {
    var velocity: Vector {
        let v = node.physicsBody?.velocity ?? .zero

        return Vector(dx: v.dx, dy: v.dy)
    }

    func setVelocity(_ velocity: Vector) {
        node.physicsBody?.velocity = CGVector(velocity)
    }
}

extension SKBallSprite {
    var radius: Double {
        size.width / 2
    }
}

extension SKBallSprite {
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
}

// MARK: Physics
extension SKBallSprite {
    func hide() {
        node.physicsBody?.categoryBitMask = disabledMask
        node.physicsBody?.contactTestBitMask = disabledMask
        node.physicsBody?.collisionBitMask = disabledMask
        node.alpha = 0
    }

    func show() {
        node.alpha = 1
        node.physicsBody?.angularVelocity = 0
        node.physicsBody?.categoryBitMask = CollisionCategory.ball.mask
        node.physicsBody?.contactTestBitMask =
            CollisionCategory.wall.mask
            | CollisionCategory.gutter.mask
            | CollisionCategory.brick.mask
            | CollisionCategory.paddle.mask
        node.physicsBody?.collisionBitMask =
            CollisionCategory.wall.mask
            | CollisionCategory.brick.mask
            | CollisionCategory.paddle.mask

    }
}
