import SpriteKit
import Testing

@testable import Breakout

struct SKBrickLayoutFactoryTest {
    private let initial: GameState = .initial(startingLives: 3)
    
    @Test func createsLayoutFromSpec() {
        let brickId = BrickId(of: "brick-001")
        let brick = Brick(
            id: brickId,
            color: .red,
            position: .zero,
        )
        
        let repository = InMemoryGameStateRepository()
        repository.save(initial.with(bricks: [brickId: brick]))
        let creator = SKBrickLayoutFactory(
            session: GameSession(
                repository: repository,
                reducer: GameReducer(),
                levelOrder: [],
                levelBricksProvider: DefaultLevelBricksProvider.empty,
                startingLives: initial.lives
            )
        )

        let layout = creator.createNodes()

        #expect(layout.children.count == 1)
    }
}
