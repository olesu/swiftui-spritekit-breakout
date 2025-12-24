import Testing

@testable import Breakout

@MainActor
struct GameSessionTest {

    // MARK: Persistance

    @Test
    func sessionReturnsPersistedStateOnInitialization() {
        let repository = InMemoryGameStateRepository()
        let initial = GameState.initial.with(score: 42)
        repository.save(initial)

        let session = makeSession(repository: repository)

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

        let session = makeSession(repository: repository)

        let brick = Brick.createValid()
        let bricks = [brick]

        session.startGame(bricks: bricks)

        let saved = repository.load()

        #expect(saved.score == 0)
        #expect(saved.lives == 3)
        #expect(saved.status == .playing)
        #expect(saved.bricks[brick.id] == brick)
    }

    @Test
    func applyingAnEventUpdatesAndPersistsState() {
        let repository = InMemoryGameStateRepository()
        let brick = Brick.createValid()

        repository.save(
            GameState.initial
                .with(status: .playing)
                .with(bricks: [brick.id: brick])
        )

        let session = makeSession(repository: repository)

        session.apply(.brickHit(brickID: brick.id))

        let saved = repository.load()

        #expect(saved.score == 7)
        #expect(saved.bricks.isEmpty)
    }

    // MARK: Reset

    @Test
    func announcingBallResetInProgressClearsFlagAndPersistsState() {
        let repository = InMemoryGameStateRepository()
        repository.save(
            GameState.initial
                .with(ballResetNeeded: true)
                .with(status: .playing)
        )

        let session = makeSession(repository: repository)

        // When acknowledging the ball reset
        session.announceBallResetInProgress()

        // Then the persisted state should have the flag cleared
        let saved = repository.load()
        #expect(saved.ballResetNeeded == false)
    }

    @Test
    func acknowledgingBallResetClearsFlagAndPersistsState() {
        let repository = InMemoryGameStateRepository()
        repository.save(
            GameState.initial
                .with(ballResetNeeded: true)
                .with(status: .playing)
        )

        let session = makeSession(repository: repository)

        session.acknowledgeBallReset()

        let saved = repository.load()
        #expect(saved.ballResetInProgress == false)
    }

    @Test
    func sessionShouldNotAcknowledgeResetAsLongAsBallResetIsNeeded() {
        let repository = InMemoryGameStateRepository()
        repository.save(
            GameState.initial
                .with(ballResetNeeded: true)
                .with(status: .playing)
        )

        let session = makeSession(repository: repository)

        session.acknowledgeBallReset()

        let saved = repository.load()
        #expect(saved.ballResetNeeded == true)
        #expect(saved.ballResetInProgress == false)
    }

    @Test
    func sessionCannotAnnounceResetInProgressUnlessResetWasNeeded() {
        let repository = InMemoryGameStateRepository()
        repository.save(
            GameState.initial
                .with(ballResetNeeded: false)
                .with(status: .playing)
        )

        let session = makeSession(repository: repository)

        session.announceBallResetInProgress()

        let saved = repository.load()
        #expect(saved.ballResetNeeded == false)
        #expect(saved.ballResetInProgress == false)
    }

    @Test
    func losingTheFinalBallMustNeverProduceBallResetInProgress() {
        let repository = InMemoryGameStateRepository()
        repository.save(
            GameState.initial
                .with(ballResetNeeded: false)
                .with(status: .playing)
                .with(lives: 1)
        )

        let session = makeSession(repository: repository)

        session.apply(.ballLost)

        let saved = repository.load()
        #expect(saved.ballResetNeeded == false)
        #expect(saved.ballResetInProgress == false)
    }

    // MARK: - Progression

    @Test func winningTheOnlyLevelEndsTheGame() {
        let brick = Brick.createValid()
        let session = makeSession(levelOrder: [.only])

        session.startGame(bricks: [brick])
        session.apply(.brickHit(brickID: brick.id))

        #expect(session.state.status == .won)
    }

    @MainActor
    private func makeSession() -> GameSession {
        makeSession(
            repository: InMemoryGameStateRepository(),
            reducer: GameReducer(),
            levelOrder: [.only]
        )
    }

    @MainActor
    private func makeSession(repository: any GameStateRepository) -> GameSession
    {
        makeSession(
            repository: repository,
            reducer: GameReducer(),
            levelOrder: [.only]
        )
    }

    @MainActor
    private func makeSession(levelOrder: [LevelId]) -> GameSession {
        makeSession(
            repository: InMemoryGameStateRepository(),
            reducer: GameReducer(),
            levelOrder: levelOrder
        )
    }

    @MainActor
    private func makeSession(
        repository: any GameStateRepository,
        reducer: GameReducer,
        levelOrder: [LevelId],
    ) -> GameSession {
        GameSession(
            repository: repository,
            reducer: reducer,
            levelOrder: levelOrder
        )
    }
}
