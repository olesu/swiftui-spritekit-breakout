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

    @Test func winningALevelWithANextLevelKeepsTheGamePlaying() {
        let brick = Brick.createValid()
        let session = makeSession(levelOrder: [.level1, .level2])

        session.startGame(bricks: [brick])
        session.apply(.brickHit(brickID: brick.id))

        #expect(session.state.status == .playing)
    }

    @Test func winningALevelAdvancesToTheNextLevel() {
        let scenario = GameSessionScenario
            .newGame
            .withLevels([
                .level1, .level2,
            ])
            .startingWith(bricks: [Brick.createValid()])

        scenario.destroyAllBricks()

        #expect(scenario.currentLevel == .level2)
    }

    @Test
    func losingInSecondLevelEndsTheGame() {
        let brick = Brick.createValid()
        let session = makeSession(levelOrder: [.level1, .level2])

        // Win level 1
        session.startGame(bricks: [brick])
        session.apply(.brickHit(brickID: brick.id))

        #expect(session.state.levelId == .level2)
        #expect(session.state.status == .playing)

        // Lose the only ball in level 2
        session.state = session.state.with(lives: 1)
        session.apply(.ballLost)

        #expect(session.state.status == .gameOver)
    }

    @Test
    func winningALevelWithANextLevelResetsBricks() {
        let brick = Brick.createValid()
        let session = makeSession(levelOrder: [.level1, .level2])

        session.startGame(bricks: [brick])
        session.apply(.brickHit(brickID: brick.id))

        #expect(session.state.bricks.isEmpty == false)
    }

    @Test
    func winningALevelLoadsBricksForNextLevel() {
        let brickLevel1 = Brick.createValid(brickId: BrickId(of: "id-1"))
        let brickLevel2 = Brick.createValid(brickId: BrickId(of: "id-2"))

        let levelBricksProvider = FakeLevelBricksProvider(
            bricksByLevel: [
                .level1: [brickLevel1.id: brickLevel1],
                .level2: [brickLevel2.id: brickLevel2],
            ]
        )

        let session = makeSession(
            levelOrder: [.level1, .level2],
            levelBricksProvider: levelBricksProvider
        )

        session.startGame(bricks: [brickLevel1])
        session.apply(.brickHit(brickID: brickLevel1.id))

        #expect(session.state.bricks.values.contains(brickLevel2))
    }

}

@MainActor
private struct GameSessionScenario {
    private let session: GameSession

    private let levels: [LevelId]
    private let bricks: [Brick]
    
    var currentLevel: LevelId {
        session.state.levelId
    }

    init(levelOrder: [LevelId]) {
        self.levels = levelOrder
        self.bricks = []

        self.session = makeSession(levelOrder: levelOrder)
    }
    
    private init(session: GameSession, levels: [LevelId], bricks: [Brick]) {
        self.session = session
        self.levels = levels
        self.bricks = bricks.map { $0 }
    }

    static let newGame = GameSessionScenario(levelOrder: [])

    func withLevels(_ levels: [LevelId]) -> GameSessionScenario {
        .init(
            levelOrder: levels.map { $0 }
        )
    }

    func startingWith(bricks: [Brick]) -> GameSessionScenario {
        let session = makeSession(levelOrder: levels)
        session.startGame(bricks: bricks)
        
        return .init(session: session, levels: levels, bricks: bricks)
    }
    
    func destroyAllBricks() {
        bricks.forEach { session.apply(.brickHit(brickID: $0.id)) }
    }
}



// MARK: Setup helpers

@MainActor
private func makeSession() -> GameSession {
    makeSession(
        repository: InMemoryGameStateRepository(),
        reducer: GameReducer(),
        levelOrder: [.only],
        levelBricksProvider: FakeLevelBricksProvider(bricksByLevel: [
            .level1: [BrickId.createValid(): Brick.createValid()],
            .level2: [BrickId.createValid(): Brick.createValid()],
        ])
    )
}

@MainActor
private func makeSession(repository: any GameStateRepository) -> GameSession
{
    makeSession(
        repository: repository,
        reducer: GameReducer(),
        levelOrder: [.only],
        levelBricksProvider: FakeLevelBricksProvider(bricksByLevel: [
            .level1: [BrickId.createValid(): Brick.createValid()],
            .level2: [BrickId.createValid(): Brick.createValid()],
        ])
    )
}

@MainActor
private func makeSession(levelOrder: [LevelId]) -> GameSession {
    makeSession(
        repository: InMemoryGameStateRepository(),
        reducer: GameReducer(),
        levelOrder: levelOrder,
        levelBricksProvider: FakeLevelBricksProvider(bricksByLevel: [
            .level1: [BrickId.createValid(): Brick.createValid()],
            .level2: [BrickId.createValid(): Brick.createValid()],
        ])
    )
}

@MainActor
private func makeSession(
    levelOrder: [LevelId],
    levelBricksProvider: LevelBricksProvider
) -> GameSession {
    makeSession(
        repository: InMemoryGameStateRepository(),
        reducer: GameReducer(),
        levelOrder: levelOrder,
        levelBricksProvider: levelBricksProvider,
    )
}

@MainActor
private func makeSession(
    repository: any GameStateRepository,
    reducer: GameReducer,
    levelOrder: [LevelId],
    levelBricksProvider: LevelBricksProvider
) -> GameSession {
    GameSession(
        repository: repository,
        reducer: reducer,
        levelOrder: levelOrder,
        levelBricksProvider: levelBricksProvider
    )
}
