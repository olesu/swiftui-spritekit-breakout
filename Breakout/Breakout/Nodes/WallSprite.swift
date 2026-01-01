import AppKit
import SpriteKit

final class WallSprite: Sprite {
    var node: SKSpriteNode

    init(position: Point, size: Size) {
        let texture = SKTexture(
            image: WallTextureFactory.diagonalStripes()
        )

        let node = SKSpriteNode(texture: texture, color: .clear, size: CGSize(size))

        node.position = CGPoint(position)
        node.alpha = 0.35
        node.physicsBody = WallPhysicsBodyConfigurer(size: CGSize(size)).physicsBody

        self.node = node
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
