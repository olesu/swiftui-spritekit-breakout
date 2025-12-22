import AppKit
import SpriteKit

final class WallSprite: SKSpriteNode {

    init(position: CGPoint, size: CGSize) {
        let texture = SKTexture(
            image: WallTextureFactory.diagonalStripes()
        )

        super.init(texture: texture, color: .clear, size: size)

        self.position = position
        self.alpha = 0.35
        self.physicsBody = WallPhysicsBodyConfigurer(size: size).physicsBody
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum WallTextureFactory {

    static func diagonalStripes(
        size: CGSize = CGSize(width: 16, height: 16)
    ) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()

        NSColor.white.withAlphaComponent(0.4).setFill()
        NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()

        NSColor.gray.withAlphaComponent(0.6).setStroke()

        let path = NSBezierPath()
        path.lineWidth = 2
        path.move(to: CGPoint(x: 0, y: size.height))
        path.line(to: CGPoint(x: size.width, y: 0))
        path.stroke()

        image.unlockFocus()
        return image
    }
}
