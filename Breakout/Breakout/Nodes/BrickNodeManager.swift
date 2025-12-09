import Foundation
import SpriteKit

final class BrickNodeManager: NodeManager {
    private let brickLayout: SKNode

    init(nodes: [NodeNames: SKNode]) {
        guard let brickLayout = nodes[.brickLayout] else { fatalError("No brick layout node found") }
        
        self.brickLayout = brickLayout
    }

    func remove(brickId: BrickId) {
        let idString = brickId.value
        brickLayout.children.first { $0.name == idString }?.removeFromParent()
    }
}
