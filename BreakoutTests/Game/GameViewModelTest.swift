import Testing
import SpriteKit
@testable import Breakout

struct GameViewModelTest {

    /*
     TDD Task List for GameViewModel:

     Node Creation:
     [x] Creates nodes via NodeCreator when createNodes() is called
     [x] Collects brick IDs during node creation
     [x] Returns nodes from NodeCreator

     Engine Management:
     [x] Creates engine with collected bricks
     [x] Starts engine after initialization
     [x] Engine receives all bricks from node creation

     Configuration:
     [ ] Exposes sceneSize from configuration
     [ ] Exposes brickArea from configuration
     */

    @Test func createsNodesViaNodeCreator() async throws {
        let fakeNodeCreator = FakeNodeCreator()
        let fakeEngine = FakeGameEngine()
        let config = GameConfigurationModel(service: PreviewGameConfigurationService())
        let viewModel = GameViewModel(
            configurationModel: config,
            nodeCreator: fakeNodeCreator,
            engineFactory: { _ in fakeEngine }
        )

        _ = viewModel.createNodes()

        #expect(fakeNodeCreator.createNodesWasCalled)
    }

    @Test func createsEngineWithBricksFromNodeCreation() async throws {
        let fakeNodeCreator = FakeNodeCreator()
        let fakeEngine = FakeGameEngine()
        var capturedBricks: Bricks?
        let config = GameConfigurationModel(service: PreviewGameConfigurationService())

        let viewModel = GameViewModel(
            configurationModel: config,
            nodeCreator: fakeNodeCreator,
            engineFactory: { bricks in
                capturedBricks = bricks
                return fakeEngine
            }
        )

        _ = viewModel.createNodes()

        #expect(capturedBricks?.bricks.count == 3)
    }

    @Test func startsEngineAfterCreation() async throws {
        let fakeNodeCreator = FakeNodeCreator()
        let fakeEngine = FakeGameEngine()
        let config = GameConfigurationModel(service: PreviewGameConfigurationService())
        let viewModel = GameViewModel(
            configurationModel: config,
            nodeCreator: fakeNodeCreator,
            engineFactory: { _ in fakeEngine }
        )

        _ = viewModel.createNodes()

        #expect(fakeEngine.startWasCalled)
    }

    @Test func engineIsAccessibleAfterNodeCreation() async throws {
        let fakeNodeCreator = FakeNodeCreator()
        let fakeEngine = FakeGameEngine()
        let config = GameConfigurationModel(service: PreviewGameConfigurationService())
        let viewModel = GameViewModel(
            configurationModel: config,
            nodeCreator: fakeNodeCreator,
            engineFactory: { _ in fakeEngine }
        )

        #expect(viewModel.engine == nil)

        _ = viewModel.createNodes()

        #expect(viewModel.engine != nil)
    }
}

class FakeNodeCreator: NodeCreator {
    var createNodesWasCalled = false

    func createNodes(onBrickAdded: @escaping (String) -> Void) -> [NodeNames: SKNode] {
        createNodesWasCalled = true

        // Simulate adding some bricks
        onBrickAdded("brick1")
        onBrickAdded("brick2")
        onBrickAdded("brick3")

        return [:]
    }
}

class FakeGameEngine: GameEngine {
    var startWasCalled = false
    var processedEvents: [GameEvent] = []

    var currentScore: Int = 0
    var remainingLives: Int = 3
    var remainingBrickCount: Int = 0
    var currentStatus: GameState = .idle

    func start() {
        startWasCalled = true
        currentStatus = .playing
    }

    func process(event: GameEvent) {
        processedEvents.append(event)
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
