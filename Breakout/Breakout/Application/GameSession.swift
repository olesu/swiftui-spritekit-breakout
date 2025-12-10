import Foundation

@Observable
final class GameSession {
    private let repository: GameStateRepository
    private let reducer: GameReducer
    
    var state: GameState {
        didSet {}
    }
    
    init(repository: GameStateRepository, reducer: GameReducer) {
        self.repository = repository
        self.reducer = reducer
        
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
        repository.save(newState)
        state = newState
    }
    
    private func reset(bricks: [Brick]) {
        let bricks = Dictionary(uniqueKeysWithValues: bricks.map { ($0.id, $0) })
        
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
