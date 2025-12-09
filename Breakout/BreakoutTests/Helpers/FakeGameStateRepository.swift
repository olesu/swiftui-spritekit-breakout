@testable import Breakout

final class FakeGameStateRepository: GameStateRepository {
    private var state: GameState
    
    init(_ state: GameState) {
        self.state = state
    }
    
    func load() -> GameState {
        state
    }
    
    func save(_ state: GameState) {
        self.state = state
    }
    
}
