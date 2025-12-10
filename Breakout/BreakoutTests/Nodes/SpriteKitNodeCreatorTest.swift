import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct SpriteKitNodeCreatorTest {
    @Test func createsNodesFromBrickSpec() {
        let creator = SpriteKitNodeCreator(
            session: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            )
        )

        let nodes = creator.createNodes()

        #expect(nodes.count == 7)
    }
}
