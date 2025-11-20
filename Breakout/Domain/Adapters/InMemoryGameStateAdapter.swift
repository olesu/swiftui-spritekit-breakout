import Foundation

internal final class InMemoryGameStateAdapter: GameStateAdapter {
    private let storage: InMemoryStorage

    internal init(storage: InMemoryStorage) {
        self.storage = storage
    }

    internal func save(_ state: GameState) {
        storage.state = state
    }

    internal func read() -> GameState {
        storage.state
    }
}
