import Foundation

final class GameSession {
    private let repository: GameStateRepository
    private let reducer: GameReducer
    private let levelOrder: [LevelId]
    private let levelBricksProvider: LevelBricksProvider
    private let startingLives: Int

    var state: GameState {
        repository.load()
    }

    init(
        repository: GameStateRepository,
        reducer: GameReducer,
        levelOrder: [LevelId],
        levelBricksProvider: LevelBricksProvider,
        startingLives: Int
    ) {
        self.repository = repository
        self.reducer = reducer
        self.levelOrder = levelOrder
        self.levelBricksProvider = levelBricksProvider
        self.startingLives = startingLives
    }

}

// MARK: - Game Startup
extension GameSession: GameStarter {
    func startGame() {
        repository.save(initializeGame(bricks: bricksForLevel()))
    }
    
    private func bricksForLevel() -> [Brick] {
        guard let firstLevel = levelOrder.first else {
            return []
        }

        let bricks = levelBricksProvider.bricks(for: firstLevel)
        return bricks.values.map { $0 }
    }

    private func initializeGame(bricks: [Brick]) -> GameState {
        reducer.start(initialWith(bricks: bricks))
    }

    private func initialWith(bricks: [Brick]) -> GameState {
        .initial(startingLives: startingLives).with(
            bricks: bricksToMap(bricks)
        )
    }

    private func bricksToMap(_ bricks: [Brick]) -> [BrickId: Brick] {
        Dictionary(
            uniqueKeysWithValues: bricks.map { ($0.id, $0) }
        )
    }
}

// MARK: - GameEventSink
extension GameSession: GameEventSink {
    func handle(_ event: GameEvent) {
        let reduced = reducer.reduce(state, event: event)

        if shouldContinueAfterWinning(previous: state, reduced: reduced),
            let next = nextLevel(after: reduced.levelId)
        {
            let bricksForNextLevel = levelBricksProvider.bricks(for: next)
            let continued =
                reduced
                .with(status: .playing)
                .with(levelId: next)
                .with(bricks: bricksForNextLevel)

            repository.save(continued)
        } else {
            repository.save(reduced)
        }

    }

    private func shouldContinueAfterWinning(
        previous: GameState,
        reduced: GameState
    ) -> Bool {
        guard previous.status == .playing else { return false }
        guard reduced.status == .won else { return false }

        return hasNextLevel(afterWonState: reduced)
    }

    private func hasNextLevel(afterWonState: GameState) -> Bool {
        guard
            let currentIndex = levelOrder.firstIndex(of: afterWonState.levelId)
        else { return false }

        return levelOrder.indices.contains(currentIndex + 1)
    }

    private func nextLevel(after level: LevelId) -> LevelId? {
        guard let index = levelOrder.firstIndex(of: level) else { return nil }
        let nextIndex = index + 1
        guard levelOrder.indices.contains(nextIndex) else { return nil }
        return levelOrder[nextIndex]
    }

}

// MARK: - RunningGame
extension GameSession: RunningGame {
    var ballResetNeeded: Bool {
        state.ball.resetNeeded
    }
    
    var visualGameState: VisualGameState {
        .init(levelId: state.levelId)
    }

    func announceBallResetInProgress() {
        repository.save(reducer.announcedBallResetInProgress(state))
    }

    func acknowledgeBallReset() {
        repository.save(reducer.acknowledgeBallReset(state))
    }

    func consumeLevelDidChange() -> Bool {
        false
    }

}

// MARK: - Snapshot
extension GameSession: GameSnapshotProvider {
    func snapshot() -> GameSessionSnapshot {
        GameSessionSnapshot(
            score: state.score,
            lives: state.lives,
            status: state.status
        )
    }
}

// MARK: - Bricks Provider
extension GameSession: BricksProvider {
    var bricks: [BrickId: Brick] {
        state.bricks
    }
}
