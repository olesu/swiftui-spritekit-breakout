import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct GameViewModelTest {

    @Test func startNewGameInitializesDomain() throws {
        let (vm, repo) = makeGameViewModel(with: .initial)

        vm.startNewGame()

        #expect(repo.load().status == .playing)
    }

    @Test func startNewGameUpdatesUIState() throws {
        let (vm, _) = makeGameViewModel(with: .initial)

        vm.startNewGame()

        #expect(vm.remainingLives == GameState.initial.lives)
        #expect(vm.currentScore == 0)
    }

    private func makeGameViewModel(with state: GameState) -> (GameViewModel, GameStateRepository) {
        let repository = FakeGameStateRepository(state)
        let model = GameViewModel(
            session: GameSession(
                repository: repository,
                reducer: GameReducer(),
                levelOrder: [],
                levelBricksProvider: DefaultLevelBricksProvider.empty
            ),
            gameConfiguration: GameConfiguration.defaultValue(),
            screenNavigationService: FakeScreenNavigationService(),
            gameResultService: FakeGameResultService(),

        )
        return (model, repository)
    }

}
