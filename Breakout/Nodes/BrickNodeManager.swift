import Foundation
import SpriteKit

class BrickNodeManager {
    private let brickLayout: SKNode

    init(brickLayout: SKNode) {
        self.brickLayout = brickLayout
    }

    func remove(brickId: UUID) {
        let idString = brickId.uuidString
        brickLayout.children.first { $0.name == idString }?.removeFromParent()
    }
}
