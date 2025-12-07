import Testing
import SpriteKit
@testable import Breakout

@MainActor
struct GameViewModelTest {
    let repository = InMemoryGameStateRepository()
    let configService = FakeGameConfigurationService()
    let navService = FakeScreenNavigationService()
    let resultService = FakeGameResultService()
    let session: GameSession
    let viewModel: GameViewModel

    init() {
        session = GameSession(
            repository: repository,
            reducer: GameReducer()
        )
        viewModel = GameViewModel(
            session: session,
            configurationService: configService,
            screenNavigationService: navService,
            gameResultService: resultService,
            nodeCreator: FakeNodeCreator()
        )
    }

    // MARK: - Initialization

    @Test
    func reflectsScoreAfterGameStarts() {
        viewModel.startNewGame()
        
        #expect(viewModel.currentScore == 0)
        #expect(viewModel.remainingLives == 3)
    }

    @Test
    func exposesSceneConfiguration() {
        let context = GameViewModelMother.makeContext()
        #expect(context.viewModel.sceneSize == CGSize(width: 320, height: 480))
        #expect(context.viewModel.brickArea == CGRect(x: 20, y: 330, width: 280, height: 120))
    }
    
    @Test
    func sceneNodesReadyIsTriggeredAfterStartingNewGame() {
        var receivedNodes: [NodeNames: SKNode]? = nil
        viewModel.onSceneNodesCreated = { nodes in
            receivedNodes = nodes
        }

        viewModel.startNewGame()

        #expect(receivedNodes != nil)
    }


    // MARK: - Ball Reset Callback

    @Test
    func ballResetCallbackIsTriggeredWhenBallResetNeeded() {
        var resetTriggered = false
        viewModel.onBallResetNeeded = { resetTriggered = true }

        repository.save(
            GameState.initial
                .with(status: .playing)
                .with(lives: 3)
        )

        viewModel.handleGameEvent(.ballLost)

        #expect(resetTriggered == true)
    }

    // MARK: - Navigation on Game End

    @Test
    func navigatingToGameEndOnGameOver() {
        repository.save(
            GameState.initial
                .with(status: .playing)
                .with(lives: 1)
        )

        viewModel.handleGameEvent(.ballLost)

        #expect(navService.didNavigateTo == .gameEnd)
    }

    @Test
    func navigatingToGameEndOnWin() {
        let id = BrickId(of: "b")
        repository.save(
            GameState.initial
                .with(status: .playing)
                .with(bricks: [id: Brick(id: id, color: .red)])
        )

        viewModel.handleGameEvent(.brickHit(brickID: id))

        #expect(navService.didNavigateTo == .gameEnd)
    }

    // MARK: - Result Saving

    @Test
    func savesResultWhenGameEndsAsWin() {
        let id = BrickId(of: "b")
        repository.save(
            GameState.initial
                .with(status: .playing)
                .with(bricks: [id: Brick(id: id, color: .red)])
        )

        viewModel.handleGameEvent(.brickHit(brickID: id))

        #expect(resultService.savedDidWin == true)
        #expect(resultService.savedScore == 7)
    }

    @Test
    func savesResultWhenGameEndsAsLoss() {
        repository.save(
            GameState.initial
                .with(status: .playing)
                .with(lives: 1)
        )

        viewModel.handleGameEvent(.ballLost)

        #expect(resultService.savedDidWin == false)
        #expect(resultService.savedScore == 0)
    }
    
}

