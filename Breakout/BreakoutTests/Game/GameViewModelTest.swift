import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct GameViewModelTest {

    @Test func startNewGameCreatesScene() throws {
        let (vm, _) = makeGameViewModel(with: .initial)
        let scene = try vm.startNewGame()

        #expect(scene.size == vm.sceneSize)
    }
    
    @Test func startNewGameInitializesDomain() throws {
        let (vm, repo) = makeGameViewModel(with: .initial)

        _ = try vm.startNewGame()

        #expect(repo.load().status == .playing)
    }

    @Test func startNewGameUpdatesUIState() throws {
        let (vm, _) = makeGameViewModel(with: .initial)

        _ = try vm.startNewGame()

        #expect(vm.remainingLives == GameState.initial.lives)
        #expect(vm.currentScore == 0)
        #expect(vm.gameStatus == .playing)
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
