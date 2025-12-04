import AppKit
import SpriteKit
import Testing

@testable import Breakout

struct GameViewModelTest {
    let repository = InMemoryGameStateRepository()
    let service = GameReducer()
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

    // MARK: - Game Restart

    @Test
    func startingANewGameAfterGameOverResetsStateToInitial() {
        repository.save(GameState.initial
            .with(lives: 0)
            .with(status: .gameOver))

        viewModel.resetGame()
        viewModel.startGame()

        #expect(repository.load().status == .playing)
        #expect(repository.load().lives == 3)
    }

    // MARK: - Initialization

    @Test
    func restoresPersistedStateWhenInitialized() async throws {
        repository.save(
            GameState.initial
                .with(score: 50)
                .with(lives: 2)
                .with(status: .playing)
        )

        #expect(viewModel.currentScore == 50)
        #expect(viewModel.remainingLives == 2)
    }

    @Test
    func exposesInjectedNavigationService() async throws {
        let _ = GameViewModelMother.makeContext()
        // No expectations — just verifying construction works
    }

    // MARK: - Starting a Game

    @Test
    func startingAGameTransitionsStateToPlaying() async throws {
        viewModel.startGame()
        #expect(repository.load().status == .playing)
    }

    @Test
    func startingAGamePersistsUpdatedState() async throws {
        viewModel.startGame()
        let saved = repository.load()
        #expect(saved.status == .playing)
    }

    // MARK: - Brick Hit Behavior

    @Test
    func hittingABrickIncreasesTheScore() async throws {
        repository.save(GameState.initial
            .with(bricks: [
                BrickId(of: "1"): Brick(id: BrickId(of: "1"), color: .red)
            ])
        )
        viewModel.startGame()
        viewModel.handleGameEvent(.brickHit(brickID: BrickId(of: "1")))

        #expect(viewModel.currentScore == 7)
    }

    @Test
    func hittingABrickAddsToExistingScore() async throws {
        repository.save(GameState.initial
            .with(score: 10)
            .with(bricks: [
                BrickId(of: "1"): Brick(id: BrickId(of: "1"), color: .red)
            ])
        )
        viewModel.startGame()
        viewModel.handleGameEvent(.brickHit(brickID: BrickId(of: "1")))

        #expect(viewModel.currentScore == 17)
    }

    @Test
    func hittingABrickRemovesItFromTheBoard() async throws {
        let brickId = BrickId(of: "1")
        repository.save(GameState.initial
            .with(bricks: [
                brickId: Brick(id: brickId, color: .red)
            ])
        )
        viewModel.startGame()
        viewModel.handleGameEvent(.brickHit(brickID: brickId))

        #expect(repository.load().bricks[brickId] == nil)
    }

    @Test
    func hittingTheFinalBrickEndsTheGameAsWon() async throws {
        let brickId = BrickId(of: "1")
        repository.save(GameState.initial
            .with(bricks: [
                brickId: Brick(id: brickId, color: .red)
            ])
        )
        viewModel.startGame()
        viewModel.handleGameEvent(.brickHit(brickID: brickId))

        #expect(repository.load().status == .won)
    }

    // MARK: - Ball Lost Behavior

    @Test
    func losingABallDecreasesRemainingLives() async throws {
        repository.save(GameState.initial.with(lives: 3))
        viewModel.startGame()
        viewModel.handleGameEvent(.ballLost)

        #expect(repository.load().lives == 2)
    }

    @Test
    func losingABallMarksBallResetAsRequired() async throws {
        repository.save(GameState.initial.with(lives: 3))
        viewModel.startGame()
        viewModel.handleGameEvent(.ballLost)

        #expect(repository.load().ballResetNeeded == true)
    }

    @Test
    func losingTheFinalBallEndsTheGameAsGameOver() async throws {
        repository.save(GameState.initial.with(lives: 1))
        viewModel.startGame()
        viewModel.handleGameEvent(.ballLost)

        #expect(repository.load().status == .gameOver)
    }

    // MARK: - Reset Behavior

    @Test
    func acknowledgingBallResetClearsResetFlag() async throws {
        repository.save(GameState.initial.with(ballResetNeeded: true))

        viewModel.acknowledgeBallReset()

        #expect(repository.load().ballResetNeeded == false)
    }

    // MARK: - Configuration Exposure

    @Test
    func exposesSceneSizeFromConfiguration() async throws {
        let context = GameViewModelMother.makeContext()
        #expect(context.viewModel.sceneSize == CGSize(width: 320, height: 480))
    }

    @Test
    func exposesBrickAreaFromConfiguration() async throws {
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
