import AppKit
import SpriteKit
import Testing

@testable import Breakout

struct GameViewModelTest {

    @Test func receivesScreenNavigationService() async throws {
        let _ = GameViewModelMother.makeContext()
    }

    @Test func initialization_loadsStateFromRepository() async throws {
        let repository = InMemoryGameStateRepository()
        let savedState = GameState.initial
            .with(score: 50)
            .with(lives: 2)
            .with(status: .playing)
        repository.save(savedState)

        let service = BreakoutGameService()
        let configService = FakeGameConfigurationService()
        let navService = FakeScreenNavigationService()
        let resultService = FakeGameResultService()

        let viewModel = GameViewModel(
            service: service,
            repository: repository,
            configurationService: configService,
            screenNavigationService: navService,
            gameResultService: resultService
        )

        #expect(viewModel.currentScore == 50)
        #expect(viewModel.remainingLives == 2)
    }

    @Test func testStartGame_callsServiceAndSavesState() async throws {
        let repository = InMemoryGameStateRepository()
        let service = BreakoutGameService()
        let configService = FakeGameConfigurationService()
        let navService = FakeScreenNavigationService()
        let resultService = FakeGameResultService()

        let viewModel = GameViewModel(
            service: service,
            repository: repository,
            configurationService: configService,
            screenNavigationService: navService,
            gameResultService: resultService
        )
        
        viewModel.startGame()

        #expect(repository.load().status == .playing)
    }

    @Test func startGame_transitionsToPlayingAndSavesState() async throws {
        let repository = InMemoryGameStateRepository()
        let service = BreakoutGameService()
        let configService = FakeGameConfigurationService()
        let navService = FakeScreenNavigationService()
        let resultService = FakeGameResultService()

        let viewModel = GameViewModel(
            service: service,
            repository: repository,
            configurationService: configService,
            screenNavigationService: navService,
            gameResultService: resultService
        )

        viewModel.startGame()

        let savedState = repository.load()
        #expect(savedState.status == .playing)
    }

    @Test func navigatesToGameEndWhenEngineTransitionsToGameOver() async throws
    {
        let context = GameViewModelMother.makeContext()
        let engine = GameEngineMother.makeEngineNearGameOver(autoStart: true)

        context.viewModel.setEngine(engine)
        context.viewModel.handleGameEvent(.ballLost)

        #expect(context.navigationService.navigatedTo == .gameEnd)
    }

    @Test func navigatesToGameEndWhenEngineTransitionsToWon() async throws {
        let context = GameViewModelMother.makeContext()
        let (engine, brickId) = GameEngineMother.makeEngineWithSingleBrick(
            autoStart: true
        )

        context.viewModel.setEngine(engine)
        context.viewModel.handleGameEvent(.brickHit(brickID: brickId))

        #expect(context.navigationService.navigatedTo == .gameEnd)
    }

    @Test func exposesSceneSizeFromConfiguration() async throws {
        let context = GameViewModelMother.makeContext()

        #expect(context.viewModel.sceneSize == CGSize(width: 320, height: 480))
    }

    @Test func exposesBrickAreaFromConfiguration() async throws {
        let context = GameViewModelMother.makeContext()

        #expect(
            context.viewModel.brickArea
                == CGRect(x: 20, y: 330, width: 280, height: 120)
        )
    }

    @Test func setsEngineCorrectly() async throws {
        let fakeEngine = FakeGameEngine()
        let context = GameViewModelMother.makeContext()

        context.viewModel.setEngine(fakeEngine)
        context.viewModel.handleGameEvent(.ballLost)

        #expect(fakeEngine.processedEvents.count == 1)
    }

    @Test func callsOnBallResetNeededWhenEngineRequestsReset() async throws {
        let fakeEngine = FakeGameEngine()
        let context = GameViewModelMother.makeContext()

        var callbackWasCalled = false
        context.viewModel.onBallResetNeeded = {
            callbackWasCalled = true
        }

        context.viewModel.setEngine(fakeEngine)
        fakeEngine.shouldResetBall = true

        context.viewModel.handleGameEvent(.ballLost)

        #expect(callbackWasCalled == true)
        #expect(fakeEngine.acknowledgeBallResetWasCalled == true)
    }

    @Test func savesWinResultWhenEngineTransitionsToWon() async throws {
        let context = GameViewModelMother.makeContext()
        let (engine, brickId) = GameEngineMother.makeEngineWithSingleBrick(
            autoStart: true
        )
        context.viewModel.setEngine(engine)

        context.viewModel.handleGameEvent(.brickHit(brickID: brickId))

        #expect(context.gameResultService.didWin == true)
        #expect(context.gameResultService.score == engine.currentScore)
    }

    @Test func savesLossResultWhenEngineTransitionsToGameOver() async throws {
        let context = GameViewModelMother.makeContext()
        let engine = GameEngineMother.makeEngineNearGameOver(autoStart: true)
        context.viewModel.setEngine(engine)

        context.viewModel.handleGameEvent(.ballLost)

        #expect(context.gameResultService.didWin == false)
        #expect(context.gameResultService.score == engine.currentScore)
    }
}

class FakeNodeCreator: NodeCreator {
    var createNodesWasCalled = false

    func createNodes(onBrickAdded: @escaping (String, BrickColor) -> Void)
        -> [NodeNames: SKNode]
    {
        createNodesWasCalled = true

        // Simulate adding some bricks
        onBrickAdded("brick1", .red)
        onBrickAdded("brick2", .yellow)
        onBrickAdded("brick3", .green)

        return [:]
    }
}

class FakeGameEngine: GameEngine {
    var startWasCalled = false
    var processedEvents: [GameEvent] = []
    var acknowledgeBallResetWasCalled = false

    var currentScore: Int = 0
    var remainingLives: Int = 3
    var currentStatus: GameStatus = .idle
    var shouldResetBall: Bool = false

    func start() {
        startWasCalled = true
    }

    func process(event: GameEvent) {
        processedEvents.append(event)
    }

    func acknowledgeBallReset() {
        acknowledgeBallResetWasCalled = true
    }
}

class FakeGameConfigurationService: GameConfigurationService {
    func getGameConfiguration() -> GameConfiguration {
        GameConfiguration(
            sceneWidth: 320,
            sceneHeight: 480,
            brickArea: BrickArea(x: 20, y: 330, width: 280, height: 120)
        )
    }

    func getGameScale() -> CGFloat {
        1.0
    }
}
