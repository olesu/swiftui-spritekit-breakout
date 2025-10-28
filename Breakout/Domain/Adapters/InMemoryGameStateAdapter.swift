import Foundation

class InMemoryGameStateAdapter: GameStateAdapter {
    private let storage: InMemoryStorage
    
    init(storage: InMemoryStorage) {
        self.storage = storage
    }
    
    func save(_ state: GameState) {
        storage.state = state
    }
    
    func read() -> GameState {
        storage.state
    }
}
