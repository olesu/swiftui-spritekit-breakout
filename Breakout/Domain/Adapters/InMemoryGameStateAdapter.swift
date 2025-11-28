import Foundation

internal final class InMemoryGameStateAdapter: GameStatusAdapter {
    private let storage: InMemoryStorage

    internal init(storage: InMemoryStorage) {
        self.storage = storage
    }

    internal func save(_ state: GameStatus) {
        storage.status = state
    }

    internal func read() -> GameStatus {
        storage.status
    }
}
