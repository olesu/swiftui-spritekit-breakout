import Foundation
import SpriteKit

final class SKBricksLayout: SpriteContainer {
    var node: SKNode

    let brickData: [BrickData]

    init(brickData: [BrickData]) {
        self.brickData = brickData
        self.node = SKNode()
        
        setupBricks(in: node)
    }

    var children: [SKNode] {
        node.children
    }

    private func setupBricks(in parent: SKNode) {
        brickData.forEach { d in
            let sprite = BrickSprite(brickData: d)
            sprite.attach(to: node)
        }
    }

}
