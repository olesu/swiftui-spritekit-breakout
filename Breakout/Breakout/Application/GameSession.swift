struct GameSession {
    let repository: GameStateRepository
    let reducer: GameReducer
    
    var state: GameState {
        repository.load()
    }
    
    func startGame() {
        repository.save(reducer.start(state))
    }
    
    func apply(_ event: GameEvent) {
        repository.save(reducer.reduce(state, event: event))
    }
    
    func reset(bricks: [BrickId: Brick]) {
        repository.save(.initial.with(bricks: bricks))
    }
    
    func acknowledgeBallReset() {
        repository.save(reducer.acknowledgeBallReset(state))
    }
}
