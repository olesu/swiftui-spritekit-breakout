import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct SpriteKitNodeCreatorTest {
    private let brickService = BrickService(adapter: FakeBrickLayoutAdapter())
    
    @Test func createsNodesFromBrickSpec() throws {
        let creator = SpriteKitNodeCreator(
            brickService: brickService,
            gameConfigurationService: FakeGameConfigurationService(),
        )

        let nodes = try creator.createNodes()

        #expect(nodes.count == 7)
    }
}

