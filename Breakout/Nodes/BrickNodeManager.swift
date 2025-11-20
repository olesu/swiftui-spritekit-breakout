import Foundation
import SpriteKit

internal final class BrickNodeManager {
    private let brickLayout: SKNode

    internal init(brickLayout: SKNode) {
        self.brickLayout = brickLayout
    }

    internal func remove(brickId: UUID) {
        let idString = brickId.uuidString
        brickLayout.children.first { $0.name == idString }?.removeFromParent()
    }
}
