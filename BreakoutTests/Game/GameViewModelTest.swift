import Testing
import SpriteKit
import AppKit
@testable import Breakout

struct GameViewModelTest {

    @Test func exposesSceneSizeFromConfiguration() async throws {
        let config = GameConfigurationModel(service: PreviewGameConfigurationService())
        let viewModel = GameViewModel(configurationModel: config)

        #expect(viewModel.sceneSize == CGSize(width: 320, height: 480))
    }

    @Test func exposesBrickAreaFromConfiguration() async throws {
        let config = GameConfigurationModel(service: PreviewGameConfigurationService())
        let viewModel = GameViewModel(configurationModel: config)

        #expect(viewModel.brickArea == CGRect(x: 20, y: 330, width: 280, height: 120))
    }

    @Test func initializesEngineWithBricks() async throws {
        let fakeEngine = FakeGameEngine()
        var capturedBricks: Bricks?
        let config = GameConfigurationModel(service: PreviewGameConfigurationService())

        let viewModel = GameViewModel(
            configurationModel: config,
            engineFactory: { bricks in
                capturedBricks = bricks
                return fakeEngine
            }
        )

        var bricks = Bricks()
        bricks.add(Brick(id: BrickId(of: "brick1"), color: .red))
        bricks.add(Brick(id: BrickId(of: "brick2"), color: .yellow))

        viewModel.initializeEngine(with: bricks)

        #expect(capturedBricks?.get(byId: BrickId(of: "brick1")) != nil)
        #expect(capturedBricks?.get(byId: BrickId(of: "brick2")) != nil)
        #expect(fakeEngine.startWasCalled)
    }

    @Test func callsOnBallResetNeededWhenEngineRequestsReset() async throws {
        let fakeEngine = FakeGameEngine()
        let config = GameConfigurationModel(service: PreviewGameConfigurationService())

        let viewModel = GameViewModel(
            configurationModel: config,
            engineFactory: { _ in fakeEngine }
        )

        var callbackWasCalled = false
        viewModel.onBallResetNeeded = {
            callbackWasCalled = true
        }

        viewModel.initializeEngine(with: Bricks())
        fakeEngine.shouldResetBall = true

        viewModel.handleGameEvent(.ballLost)

        #expect(callbackWasCalled == true)
        #expect(fakeEngine.acknowledgeBallResetWasCalled == true)
    }
}

class FakeNodeCreator: NodeCreator {
    var createNodesWasCalled = false

    func createNodes(onBrickAdded: @escaping (String, BrickColor) -> Void) -> [NodeNames: SKNode] {
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

class PreviewGameConfigurationService: GameConfigurationService {
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
