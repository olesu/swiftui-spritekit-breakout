import SpriteKit
import Testing

@testable import Breakout

struct GameViewModelTest {
    let initial: GameState = .initial(startingLives: 3)

    @Test func startNewGameInitializesDomain() throws {
        let (vm, repo) = makeGameViewModel(with: initial)

        vm.startNewGame()

        #expect(repo.load().status == .playing)
    }

    @Test func startNewGameUpdatesUIState() throws {
        let (vm, _) = makeGameViewModel(with: initial)

        vm.startNewGame()

        #expect(vm.remainingLives == initial.lives)
        #expect(vm.currentScore == 0)
    }

    private func makeGameViewModel(
        with state: GameState,
        screenNavigationService: ScreenNavigationService =
            FakeScreenNavigationService(),
        gameResultService: GameResultService = FakeGameResultService(),
    ) -> (GameViewModel, GameStateRepository) {
        let repository = FakeGameStateRepository(state)
        let model = GameViewModel(
            session: GameSession(
                repository: repository,
                reducer: GameReducer(),
                levelOrder: [],
                levelBricksProvider: DefaultLevelBricksProvider.empty,
                startingLives: state.lives,
            ),
            gameConfiguration: GameConfiguration.defaultValue(),
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService,

        )
        return (model, repository)
    }

}
