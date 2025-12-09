struct GameSession {
    let repository: GameStateRepository
    let reducer: GameReducer
    
    var state: GameState {
        repository.load()
    }
    
    func startGame(bricks: [Brick]) {
        reset(bricks: bricks)
        repository.save(reducer.start(state))
    }
    
    func apply(_ event: GameEvent) {
        repository.save(reducer.reduce(state, event: event))
    }
    
    private func reset(bricks: [Brick]) {
        let bricks = Dictionary(uniqueKeysWithValues: bricks.map { ($0.id, $0) })
        
        repository.save(.initial.with(bricks: bricks))
    }
    
    func acknowledgeBallReset() {
        repository.save(reducer.acknowledgeBallReset(state))
    }
}
