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
            nodeCreator: SpriteKitNodeCreator(layoutLoader: LoadBrickLayoutService(adapter: JsonBrickLayoutAdapter()))
        )
    }

    // MARK: - Initialization

    @Test
    func exposesPersistedStateOnInitialization() {
        repository.save(
            GameState.initial
                .with(score: 99)
                .with(lives: 2)
                .with(status: .playing)
        )

        #expect(viewModel.currentScore == 99)
        #expect(viewModel.remainingLives == 2)
    }

    @Test
    func exposesSceneConfiguration() {
        let context = GameViewModelMother.makeContext()
        #expect(context.viewModel.sceneSize == CGSize(width: 320, height: 480))
        #expect(context.viewModel.brickArea == CGRect(x: 20, y: 330, width: 280, height: 120))
    }

    // MARK: - Score Callback

    @Test
    func scoreCallbackIsTriggeredOnScoreChange() {
        var callbackScore: Int?
        viewModel.onScoreChanged = { callbackScore = $0 }

        // Arrange: one brick that gives 7 points
        let id = BrickId(of: "b")
        repository.save(
            GameState.initial
                .with(status: .playing)
                .with(bricks: [id: Brick(id: id, color: .red)])
        )

        viewModel.handleGameEvent(.brickHit(brickID: id))

        #expect(callbackScore == 7)
    }

    // MARK: - Lives Callback

    @Test
    func livesCallbackIsTriggeredOnLifeLost() {
        var callbackLives: Int?
        viewModel.onLivesChanged = { callbackLives = $0 }

        repository.save(
            GameState.initial
                .with(status: .playing)
                .with(lives: 3)
        )

        viewModel.handleGameEvent(.ballLost)

        #expect(callbackLives == 2)
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

