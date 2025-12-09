import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct GameViewModelTest {
    @Test func startsANewGame() throws {
        let (m, stateRepository) = makeGameViewModel(with: .initial)

        let _ = try m.startNewGame()

        #expect(
            stateRepository.load() == GameState.initial.with(status: .playing)
        )
    }

    private func makeGameViewModel(with state: GameState) -> (
        GameViewModel, GameStateRepository
    ) {
        let repository = FakeGameStateRepository(state)
        let model = GameViewModel(
            session: GameSession(
                repository: repository,
                reducer: GameReducer()
            ),
            configurationService: FakeGameConfigurationService(),
            screenNavigationService: FakeScreenNavigationService(),
            gameResultService: FakeGameResultService(),
            nodeCreator: FakeNodeCreator(),
            collisionRouter: FakeCollisionRouter(),
            brickService: BrickService(
                adapter: FakeBrickLayoutAdapter()
            )

        )
        return (model, repository)
    }

}
