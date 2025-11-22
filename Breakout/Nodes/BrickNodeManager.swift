import Foundation
import SpriteKit

internal final class BrickNodeManager {
    private let brickLayout: SKNode

    internal init(brickLayout: SKNode) {
        self.brickLayout = brickLayout
    }

    internal func remove(brickId: BrickId) {
        let idString = brickId.value
        brickLayout.children.first { $0.name == idString }?.removeFromParent()
    }
}
