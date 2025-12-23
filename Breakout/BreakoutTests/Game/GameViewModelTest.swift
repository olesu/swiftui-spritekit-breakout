import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct GameViewModelTest {

    @Test func startNewGameCreatesScene() throws {
        let (vm, _) = makeGameViewModel(with: .initial)
        try vm.startNewGame()
    }

    @Test func startNewGameInitializesDomain() throws {
        let (vm, repo) = makeGameViewModel(with: .initial)

        _ = try vm.startNewGame()

        #expect(repo.load().status == .playing)
    }

    @Test func startNewGameUpdatesUIState() throws {
        let (vm, _) = makeGameViewModel(with: .initial)

        try vm.startNewGame()

        #expect(vm.remainingLives == GameState.initial.lives)
        #expect(vm.currentScore == 0)
    }

    @Test func startNewGameUsesLayoutFromStartingLevel() throws {
        let layoutFileName = "any_test_level"
        let brickService = FakeBrickService()
        let startingLevel = StartingLevel(layoutFileName: layoutFileName)

        let (vm, _) = makeGameViewModel(
            with: .initial,
            brickService: brickService,
            startingLevel: startingLevel
        )

        _ = try vm.startNewGame()

        #expect(brickService.loadedLayoutName == layoutFileName)
    }

    private func makeGameViewModel(
        with state: GameState,
        brickService: FakeBrickService = FakeBrickService(),
        startingLevel: StartingLevel = StartingLevel(layoutFileName: "ignored")
    ) -> (
        GameViewModel, GameStateRepository
    ) {
        let repository = FakeGameStateRepository(state)
        let model = GameViewModel(
            session: GameSession(
                repository: repository,
                reducer: GameReducer()
            ),
            gameConfiguration: GameConfiguration.defaultValue(),
            screenNavigationService: FakeScreenNavigationService(),
            gameResultService: FakeGameResultService(),
            brickService: brickService,
            startingLevel: startingLevel

        )
        return (model, repository)
    }

}
