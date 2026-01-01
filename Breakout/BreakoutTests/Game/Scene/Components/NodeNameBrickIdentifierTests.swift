import SpriteKit
import Testing

@testable import Breakout

struct NodeNameBrickIdentifierTests {

    @Test func extractsBrickIdFromNodeName() {
        let node = SKNode()
        node.name = "brick-123"

        let id = NodeNameBrickIdentifier().brickId(from: node)

        #expect(id == BrickId(of: "brick-123"))
    }

    @Test func returnsNilForUnnamedNode() {
        let node = SKNode()

        let id = NodeNameBrickIdentifier().brickId(from: node)

        #expect(id == nil)
    }

}
