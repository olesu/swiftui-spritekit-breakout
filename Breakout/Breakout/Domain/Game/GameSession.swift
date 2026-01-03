import Foundation

final class GameSession: GameEventSink, RunningGame {
    private let repository: GameStateRepository
    private let reducer: GameReducer
    private let levelOrder: [LevelId]
    private let levelBricksProvider: LevelBricksProvider
    private let startingLives: Int

    var state: GameState {
        repository.load()
    }

    var ballResetNeeded: Bool {
        state.ball.resetNeeded
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

    func startGame() {
        guard let firstLevel = levelOrder.first else {
            initializeGame(bricks: [])
            return
        }

        let bricks = levelBricksProvider.bricks(for: firstLevel)
        initializeGame(bricks: bricks.values.map { $0 })
    }

    private func initializeGame(bricks: [Brick]) {
        reset(bricks: bricks)
        repository.save(reducer.start(state))
    }

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

    private func nextLevel(after level: LevelId) -> LevelId? {
        guard let index = levelOrder.firstIndex(of: level) else { return nil }
        let nextIndex = index + 1
        guard levelOrder.indices.contains(nextIndex) else { return nil }
        return levelOrder[nextIndex]
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

    private func reset(bricks: [Brick]) {
        let bricks = Dictionary(
            uniqueKeysWithValues: bricks.map { ($0.id, $0) }
        )

        repository.save(
            GameState.initial(startingLives: startingLives).with(
                bricks: bricks
            )
        )
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

extension GameSession {
    func snapshot() -> GameSessionSnapshot {
        GameSessionSnapshot(
            score: state.score,
            lives: state.lives,
            status: state.status
        )
    }
}
