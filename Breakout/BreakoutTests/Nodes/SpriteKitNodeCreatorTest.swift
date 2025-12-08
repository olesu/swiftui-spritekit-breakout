import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct SpriteKitNodeCreatorTest {
    @Test func createsNodesFromBrickSpec() throws {
        let creator = SpriteKitNodeCreator(bricks: [
            Brick(
                id: BrickId(of: "brick-001"),
                color: .red,
                position: .zero,
            )
        ])

        let nodes = creator.createNodes()

        #expect(nodes.count == 7)
    }
}
