import Testing

@testable import Breakout

@MainActor
struct GameSessionTest {

    @Test
    func sessionReturnsPersistedStateOnInitialization() {
        let repository = InMemoryGameStateRepository()
        let initial = GameState.initial.with(score: 42)
        repository.save(initial)

        let session = GameSession(repository: repository, reducer: GameReducer())

        #expect(session.state == initial)
    }
    
    @Test
    func startingAGameUpdatesAndPersistsState() {
        let repository = InMemoryGameStateRepository()
        let oldState = GameState.initial
            .with(score: 100)
            .with(lives: 0)
            .with(status: .gameOver)

        repository.save(oldState)

        let session = GameSession(repository: repository, reducer: GameReducer())

        let brickId = BrickId(of: "1")
        let brick = Brick(id: brickId, color: .red, position: .zero)
        let bricks = [brick]

        session.startGame(bricks: bricks)

        let saved = repository.load()

        #expect(saved.score == 0)
        #expect(saved.lives == 3)
        #expect(saved.status == .playing)
        #expect(saved.bricks[brickId] == brick)
    }
    
    @Test
    func applyingAnEventUpdatesAndPersistsState() {
        let repository = InMemoryGameStateRepository()
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
    func acknowledgingBallResetClearsFlagAndPersistsState() {
        let repository = InMemoryGameStateRepository()
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
