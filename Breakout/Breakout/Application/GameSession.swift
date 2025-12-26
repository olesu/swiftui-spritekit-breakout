import Foundation

@Observable
final class GameSession {
    private let repository: GameStateRepository
    private let reducer: GameReducer
    private let levelOrder: [LevelId]
    private let levelBricksProvider: LevelBricksProvider

    var state: GameState {
        didSet {}
    }

    init(
        repository: GameStateRepository,
        reducer: GameReducer,
        levelOrder: [LevelId],
        levelBricksProvider: LevelBricksProvider
    ) {
        self.repository = repository
        self.reducer = reducer
        self.levelOrder = levelOrder
        self.levelBricksProvider = levelBricksProvider

        self.state = repository.load()
    }

    func startGame(bricks: [Brick]) {
        reset(bricks: bricks)
        let newState = reducer.start(state)
        repository.save(newState)
        state = newState
    }

    func apply(_ event: GameEvent) {
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
            state = continued

            return
        }

        repository.save(reduced)
        state = reduced
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

        let newState = GameState.initial.with(bricks: bricks)
        repository.save(newState)
        state = newState
    }

    func announceBallResetInProgress() {
        let newState = reducer.announcedBallResetInProgress(state)
        repository.save(newState)
        state = newState
    }

    func acknowledgeBallReset() {
        let newState = reducer.acknowledgeBallReset(state)
        repository.save(newState)
        state = newState
    }
}
