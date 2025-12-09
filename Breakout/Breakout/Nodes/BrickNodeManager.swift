import Foundation
import SpriteKit

final class BrickNodeManager: NodeManager {
    private let nodesByName: [NodeNames: SKNode]

    private var brickLayout: SKNode {
        nodesByName
            .filter { $0.key == .brickLayout }
            .map { $1 }
            .first ?? SKNode()
    }

    var allNodes: [SKNode] {
        nodesByName.map { $1 }
    }

    init(nodes: [NodeNames: SKNode]) {
        self.nodesByName = nodes
    }

    func remove(brickId: BrickId) {
        let idString = brickId.value
        brickLayout.children.first { $0.name == idString }?.removeFromParent()
    }
}
