import AppKit
import SpriteKit
import Testing

@testable import Breakout

struct GameViewModelTest {

    @Test func receivesScreenNavigationService() async throws {
        let _ = GameViewModelMother.makeGameViewModel()
    }

    @Test func navigatesToGameEndWhenEngineTransitionsToGameOver() async throws
    {
        let (viewModel, fakeScreenNavigationService) =
            GameViewModelMother.makeGameViewModelAndScreenNavigationService()
        let engine = GameEngineMother.makeEngineNearGameOver(autoStart: true)
        viewModel.setEngine(engine)
        viewModel.handleGameEvent(.ballLost)

        #expect(fakeScreenNavigationService.navigatedTo == .gameEnd)
    }

    @Test func navigatesToGameEndWhenEngineTransitionsToWon() async throws {
        let (viewModel, fakeScreenNavigationService) =
            GameViewModelMother.makeGameViewModelAndScreenNavigationService()
        let (engine, brickId) = GameEngineMother.makeEngineWithSingleBrick(autoStart: true)
        viewModel.setEngine(engine)
        viewModel.handleGameEvent(.brickHit(brickID: brickId))

        #expect(fakeScreenNavigationService.navigatedTo == .gameEnd)
    }

    @Test func exposesSceneSizeFromConfiguration() async throws {
        let viewModel = GameViewModelMother.makeGameViewModel()

        #expect(viewModel.sceneSize == CGSize(width: 320, height: 480))
    }

    @Test func exposesBrickAreaFromConfiguration() async throws {
        let viewModel = GameViewModelMother.makeGameViewModel()

        #expect(
            viewModel.brickArea
                == CGRect(x: 20, y: 330, width: 280, height: 120)
        )
    }

    @Test func setsEngineCorrectly() async throws {
        let fakeEngine = FakeGameEngine()
        let viewModel = GameViewModelMother.makeGameViewModel()

        viewModel.setEngine(fakeEngine)

        // Verify engine is set by processing an event
        viewModel.handleGameEvent(.ballLost)

        #expect(fakeEngine.processedEvents.count == 1)
    }

    @Test func callsOnBallResetNeededWhenEngineRequestsReset() async throws {
        let fakeEngine = FakeGameEngine()
        let viewModel = GameViewModelMother.makeGameViewModel()

        var callbackWasCalled = false
        viewModel.onBallResetNeeded = {
            callbackWasCalled = true
        }

        viewModel.setEngine(fakeEngine)
        fakeEngine.shouldResetBall = true

        viewModel.handleGameEvent(.ballLost)

        #expect(callbackWasCalled == true)
        #expect(fakeEngine.acknowledgeBallResetWasCalled == true)
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
    var currentState: GameState = .idle
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
