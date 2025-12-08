import Testing

@testable import Breakout

@MainActor
struct GameSessionTest {
    let repository = InMemoryGameStateRepository()

    @Test
    func sessionReturnsPersistedStateOnInitialization() {
        let initial = GameState.initial.with(score: 42)
        repository.save(initial)

        let session = GameSession(repository: repository, reducer: GameReducer())

        #expect(session.state == initial)
    }
    
    @Test
    func startingAGameUpdatesAndPersistsState() {
        repository.save(GameState.initial)

        let session = GameSession(repository: repository, reducer: GameReducer())

        session.startGame()

        let savedState = repository.load()
        #expect(savedState.status == .playing)
    }
    
    @Test
    func applyingAnEventUpdatesAndPersistsState() {
        let brickId = BrickId(of: "1")
        let brick = Brick(id: brickId, color: .red, position: .zero)

        repository.save(
            GameState.initial
                .with(status: .playing)
                .with(bricks: [brickId: brick])
        )

        let session = GameSession(repository: repository, reducer: GameReducer())

        session.apply(.brickHit(brickID: brickId))

        let saved = repository.load()
        
        #expect(saved.score == 7)
        #expect(saved.bricks.isEmpty)
    }
    
    @Test
    func resettingTheGameReplacesStateWithFreshInitialState() {
        let oldState = GameState.initial
            .with(score: 100)
            .with(lives: 0)
            .with(status: .gameOver)

        repository.save(oldState)

        let session = GameSession(repository: repository, reducer: GameReducer())

        let brickId = BrickId(of: "1")
        let bricks: [BrickId: Brick] = [brickId: Brick(id: brickId, color: .red, position: .zero)]

        session.reset(bricks: bricks)

        let saved = repository.load()

        #expect(saved.score == 0)
        #expect(saved.lives == 3)
        #expect(saved.status == .idle)
        #expect(saved.bricks == bricks)
    }
    
    @Test
    func acknowledgingBallResetClearsFlagAndPersistsState() {
        repository.save(
            GameState.initial
                .with(ballResetNeeded: true)
                .with(status: .playing)
        )

        let session = GameSession(repository: repository, reducer: GameReducer())

        // When acknowledging the ball reset
        session.acknowledgeBallReset()

        // Then the persisted state should have the flag cleared
        let saved = repository.load()
        #expect(saved.ballResetNeeded == false)
    }

}
