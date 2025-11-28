import AppKit
import SpriteKit
import Testing

@testable import Breakout

struct GameViewModelTest {
    let repository = InMemoryGameStateRepository()
    let service = BreakoutGameService()
    let configService = FakeGameConfigurationService()
    let navService = FakeScreenNavigationService()
    let resultService = FakeGameResultService()

    let viewModel: GameViewModel

    init() async throws {
        viewModel = GameViewModel(
            service: service,
            repository: repository,
            configurationService: configService,
            screenNavigationService: navService,
            gameResultService: resultService
        )
    }

    @Test func receivesScreenNavigationService() async throws {
        let _ = GameViewModelMother.makeContext()
    }

    @Test func initialization_loadsStateFromRepository() async throws {
        repository.save(
            GameState.initial
                .with(score: 50)
                .with(lives: 2)
                .with(status: .playing)
        )

        #expect(viewModel.currentScore == 50)
        #expect(viewModel.remainingLives == 2)
    }

    @Test func testStartGame_callsServiceAndSavesState() async throws {
        viewModel.startGame()

        #expect(repository.load().status == .playing)
    }

    @Test func startGame_transitionsToPlayingAndSavesState() async throws {
        viewModel.startGame()

        let savedState = repository.load()
        #expect(savedState.status == .playing)
    }

    @Test func testHandleGameEvent_brickHit_updatesScore() async throws {
        repository.save(GameState.initial
            .with(bricks: [
                BrickId(of: "1"): Brick(
                    id: BrickId(of: "1"),
                    color: .red
                )
            ])
        )
        viewModel.startGame()
        viewModel.handleGameEvent(
            .brickHit(brickID: BrickId(of: "1"))
        )

        #expect(viewModel.currentScore == 7)
    }

    @Test func testHandleGameEvent_brickHit_addsToExistingScore() async throws {
        repository.save(GameState.initial
            .with(score: 10)
            .with(bricks: [
                BrickId(of: "1"): Brick(
                    id: BrickId(of: "1"),
                    color: .red
                )
            ])
        )
        viewModel.startGame()
        viewModel.handleGameEvent(
            .brickHit(brickID: BrickId(of: "1"))
        )

        #expect(viewModel.currentScore == 17)
    }

    @Test func testHandleGameEvent_brickHit_removesBrick() async throws {
        let brickId = BrickId(of: "1")
        repository.save(GameState.initial
            .with(bricks: [
                brickId: Brick(id: brickId, color: .red)
            ])
        )
        viewModel.startGame()
        viewModel.handleGameEvent(.brickHit(brickID: brickId))

        let savedState = repository.load()
        #expect(savedState.bricks[brickId] == nil)
    }

    @Test func testHandleGameEvent_lastBrickHit_transitionsToWon() async throws {
        let brickId = BrickId(of: "1")
        repository.save(GameState.initial
            .with(bricks: [
                brickId: Brick(id: brickId, color: .red)
            ])
        )
        viewModel.startGame()
        viewModel.handleGameEvent(.brickHit(brickID: brickId))

        let savedState = repository.load()
        #expect(savedState.status == .won)
    }

    @Test func testHandleGameEvent_ballLost_decreasesLives() async throws {
        repository.save(GameState.initial.with(lives: 3))
        viewModel.startGame()
        viewModel.handleGameEvent(.ballLost)

        let savedState = repository.load()
        #expect(savedState.lives == 2)
    }

    @Test func testHandleGameEvent_ballLost_setsBallResetNeeded() async throws {
        repository.save(GameState.initial.with(lives: 3))
        viewModel.startGame()
        viewModel.handleGameEvent(.ballLost)

        let savedState = repository.load()
        #expect(savedState.ballResetNeeded == true)
    }

    @Test func testHandleGameEvent_ballLost_transitionsToGameOverWhenNoLivesLeft() async throws {
        repository.save(GameState.initial.with(lives: 1))
        viewModel.startGame()
        viewModel.handleGameEvent(.ballLost)

        let savedState = repository.load()
        #expect(savedState.status == .gameOver)
    }

    @Test func testAcknowledgeBallReset_clearsBallResetFlag() async throws {
        repository.save(GameState.initial.with(ballResetNeeded: true))

        viewModel.acknowledgeBallReset()

        let savedState = repository.load()
        #expect(savedState.ballResetNeeded == false)
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
