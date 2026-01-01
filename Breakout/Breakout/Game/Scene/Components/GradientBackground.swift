import SpriteKit
import Foundation

struct GradientBackground {
    static func create(with size: CGSize) -> SKNode {
        let gradientTexture = createGradientTexture(size)
        let background = SKSpriteNode(texture: gradientTexture)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        return background
    }

    static private func createGradientTexture(_ size: CGSize) -> SKTexture {
        let image = NSImage(size: size, flipped: false) { _ in
            let colors = [
                NSColor(
                    red: 0x1a / 255,
                    green: 0x1a / 255,
                    blue: 0x2e / 255,
                    alpha: 1.0
                ),
                NSColor(
                    red: 0x16 / 255,
                    green: 0x21 / 255,
                    blue: 0x3e / 255,
                    alpha: 1.0
                )
            ]
            let gradient = NSGradient(colors: colors)!
            gradient.draw(
                from: CGPoint(x: 0, y: size.height),
                to: CGPoint(x: 0, y: 0),
                options: []
            )
            return true
        }
        return SKTexture(image: image)
    }

}
