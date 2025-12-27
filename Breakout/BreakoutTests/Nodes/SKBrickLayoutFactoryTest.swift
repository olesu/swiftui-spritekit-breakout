import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct SKBrickLayoutFactoryTest {
    @Test func createsLayoutFromSpec() {
        let brickId = BrickId(of: "brick-001")
        let brick = Brick(
            id: brickId,
            color: .red,
            position: .zero,
        )
        
        let repository = InMemoryGameStateRepository()
        repository.save(GameState.initial.with(bricks: [brickId: brick]))
        let creator = SKBrickLayoutFactory(
            session: GameSession(
                repository: repository,
                reducer: GameReducer(),
                levelOrder: [],
                levelBricksProvider: DefaultLevelBricksProvider.empty
            )
        )

        let layout = creator.createNodes()

        #expect(layout.children.count == 1)
    }
}
