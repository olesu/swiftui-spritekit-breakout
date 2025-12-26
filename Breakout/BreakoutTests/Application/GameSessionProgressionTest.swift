import Testing

@testable import Breakout

@MainActor
struct GameSessionProgressionTest {
    @Test func winningTheOnlyLevelEndsTheGame() {
        let scenario = GameSessionScenario
            .newGame
            .withLevels([.only])
            .startingWith(bricks: [Brick.createValid()])
        
        scenario.destroyAllBricks()

        #expect(scenario.gameStatus == .won)
    }

    @Test func winningALevelWithANextLevelKeepsTheGamePlaying() {
        let scenario = GameSessionScenario
            .newGame
            .withLevels([.level1, .level2,])
            .startingWith(bricks: [Brick.createValid()])
        
        scenario.destroyAllBricks()

        #expect(scenario.gameStatus == .playing)
    }

    @Test func winningALevelAdvancesToTheNextLevel() {
        let scenario = GameSessionScenario
            .newGame
            .withLevels([.level1, .level2,])
            .startingWith(bricks: [Brick.createValid()])

        scenario.destroyAllBricks()

        #expect(scenario.currentLevel == .level2)
    }

    @Test
    func losingInSecondLevelEndsTheGame() {
        let scenario = GameSessionScenario
            .newGame
            .withLevels([.level1, .level2,])
            .startingWith(bricks: [Brick.createValid()])
        
        scenario.destroyAllBricks()
        scenario.loseAllBalls()

        #expect(scenario.gameStatus == .gameOver)
    }

    @Test
    func winningALevelWithANextLevelResetsBricks() {
        let scenario = GameSessionScenario
            .newGame
            .withLevels([.level1, .level2,])
            .startingWith(bricks: [Brick.createValid()])

        scenario.destroyAllBricks()

        #expect(scenario.hasBricksInPlay == true)
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
    
    var gameStatus: GameStatus {
        session.state.status
    }
    
    var hasBricksInPlay: Bool {
        !session.state.bricks.isEmpty
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
    
    func loseAllBalls() {
        for _ in 0..<session.state.lives {
            session.apply(.ballLost)
        }
    }
}

// MARK: Setup helpers

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
