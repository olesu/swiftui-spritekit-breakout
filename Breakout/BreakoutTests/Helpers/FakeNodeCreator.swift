import SpriteKit

@testable import Breakout

struct FakeBrickLayoutFactory: BrickLayoutFactory {
    private let container = TestContainer()

    func createNodes() -> SpriteContainer {
        return container
    }

    func addToContainer(_ sprite: Sprite) {
        container.addChild(sprite.node)
    }

    func hasParent(_ brickId: BrickId) -> Bool {
        container.hasBrick(with: brickId)
    }

    func position(of brickId: BrickId) -> CGPoint {
        guard let node = container.findNode(named: brickId.value) else {
            return CGPoint(x: Int.max, y: Int.max)
        }

        return node.position
    }
}

private class TestContainer: SpriteContainer {
    var node: SKNode
    var children: [SKNode] {
        node.children
    }

    init() {
        node = SKNode()
    }

    func addChild(_ child: SKNode) {
        node.addChild(child)
    }

    func hasBrick(with id: BrickId) -> Bool {
        return node.children.contains(where: { $0.name == id.value })
    }

    func position(of id: BrickId) -> CGPoint {
        guard let node = node.childNode(withName: id.value) else {
            return CGPoint(x: Int.max, y: Int.max)
        }

        return node.position
    }

    func findNode(named name: String) -> SKNode? {
        node.childNode(withName: name)
    }
}
