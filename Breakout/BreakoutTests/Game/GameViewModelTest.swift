import SpriteKit
import Testing

@testable import Breakout

struct GameViewModelTest {
    let initial: GameState = .initial(startingLives: 3)

    @Test func startNewGameInitializesDomain() throws {
        let game = FakeGameGateway()
        let vm = makeGameViewModel(game: game)

        vm.startNewGame()

        #expect(game.wasStarted())
    }

    @Test func startNewGameUpdatesUIState() throws {
        let game = FakeGameGateway()
        let vm = makeGameViewModel(game: game)

        game.setSnapshot(GameSessionSnapshot(score: 0, lives: 5, status: .playing))
        vm.startNewGame()

        #expect(vm.remainingLives == 5)
        #expect(vm.currentScore == 0)
        #expect(vm.gameStatus == .playing)
    }

    private func makeGameViewModel(
        game: GameStarter & GameSnapshotProvider = FakeGameGateway(),
        screenNavigationService: ScreenNavigationService =
            FakeScreenNavigationService(),
        gameResultService: GameResultService = FakeGameResultService(),
    ) -> GameViewModel {
        let model = GameViewModel(
            game: game,
            gameConfiguration: GameConfiguration.defaultValue(),
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService,

        )
        return model
    }

}

private final class FakeGameGateway: GameStarter, GameSnapshotProvider {
    private var _gameWasStarted: Bool = false
    private var _snapshot: GameSessionSnapshot? = nil
    
    func startGame() {
        _gameWasStarted = true
    }

    func snapshot() -> GameSessionSnapshot {
        _snapshot ?? .init(score: -1, lives: -1, status: .idle)
    }
    
    func setSnapshot(_ snapshot: GameSessionSnapshot) {
        _snapshot = snapshot
    }
    
    func wasStarted() -> Bool {
        _gameWasStarted
    }
}
