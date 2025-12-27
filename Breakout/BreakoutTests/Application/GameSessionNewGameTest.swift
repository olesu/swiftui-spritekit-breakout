import Testing

@testable import Breakout

@MainActor
struct GameSessionNewGameTest {
    @Test
    func startingAGameWithNoLevelsIsStillPlaying() {
        let session = makeSession(
            levelOrder: [],
            levelBricksProvider: FakeLevelBricksProvider(bricksByLevel: [:])
        )

        session.startGame()

        #expect(session.state.status == .playing)
        #expect(session.state.bricks.isEmpty)
    }

    @Test
    func startingANewGameLoadsBricksForTheFirstLevel() {
        let brickLevel1 = Brick.createValid(brickId: BrickId(of: "id-1"))

        let levelBricksProvider = FakeLevelBricksProvider(
            bricksByLevel: [
                .level1: [brickLevel1.id: brickLevel1],
            ]
        )

        let session = makeSession(
            levelOrder: [.level1, .level2],
            levelBricksProvider: levelBricksProvider
        )

        session.startGame()

        #expect(session.state.levelId == .level1)
        #expect(session.state.bricks.values.contains(brickLevel1))
    }

}

// MARK: Setup helpers

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
