import Foundation
import SpriteKit

final class BrickNodeManager: NodeManager {
    private let brickLayout: SKNode

    init(brickLayout: SKNode) {
        self.brickLayout = brickLayout
    }

    func remove(brickId: BrickId) {
        let idString = brickId.value
        brickLayout.children.first { $0.name == idString }?.removeFromParent()
    }
}
