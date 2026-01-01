import Foundation

final class InMemoryGameStateRepository: GameStateRepository {
    private var storedState: GameState = GameState.initial(startingLives: 999)

    init(initialState: GameState = .initial(startingLives: 999)) {
        storedState = initialState
    }

    internal func load() -> GameState {
        return storedState
    }

    internal func save(_ state: GameState) {
        storedState = state
    }
}
