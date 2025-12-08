import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct SpriteKitNodeCreatorTest {
    @Test func createsNodesFromBrickSpec() throws {
        let creator = SpriteKitNodeCreator(brickLayoutData: [
            BrickLayoutData(
                position: CGPoint(x: 0, y: 0),
                color: .red
            )
        ])

        var bricksAdded: [(String, BrickColor)] = []
        _ = creator.createNodes { brick in
            bricksAdded.append((brick.id.value, brick.color))
        }

        #expect(bricksAdded.count == 1)
        #expect(bricksAdded[0].0 != "")
        #expect(bricksAdded[0].1 == .red)
    }
}
