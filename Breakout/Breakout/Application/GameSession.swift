import Foundation

@Observable
final class GameSession {
    private let repository: GameStateRepository
    private let reducer: GameReducer
    private let levelOrder: [LevelId]

    var state: GameState {
        didSet {}
    }

    init(
        repository: GameStateRepository,
        reducer: GameReducer,
        levelOrder: [LevelId]
    ) {
        self.repository = repository
        self.reducer = reducer
        self.levelOrder = levelOrder

        self.state = repository.load()
    }

    func startGame(bricks: [Brick]) {
        reset(bricks: bricks)
        let newState = reducer.start(state)
        repository.save(newState)
        state = newState
    }

    func apply(_ event: GameEvent) {
        let newState = reducer.reduce(state, event: event)
        
        if state.status == .playing {
            let afterWonState = newState.with(status: .won)
            if hasNextLevel(afterWonState: afterWonState) {
                let continuedState = afterWonState.with(status: .playing)
                repository.save(continuedState)
                state = continuedState
                
                return
            }
        }
        
        repository.save(newState)
        state = newState
    }
    
    private func hasNextLevel(afterWonState: GameState) -> Bool {
        guard let currentIndex = levelOrder.firstIndex(of: afterWonState.levelId) else { return false}
        
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
