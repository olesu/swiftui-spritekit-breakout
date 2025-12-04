import Foundation

internal final class InMemoryGameStateRepository: GameStateRepository {
    private var storedState: GameState = GameState.initial

    internal func load() -> GameState {
        return storedState
    }

    internal func save(_ state: GameState) {
        storedState = state
    }
}
