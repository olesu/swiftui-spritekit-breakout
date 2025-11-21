import Foundation

/// Represents the current state of the game session.
internal enum GameState {
    /// Game is idle, waiting to start.
    case idle
    /// Game is actively being played.
    case playing
    /// Player has won by destroying all bricks.
    case won
    /// Player has lost all lives.
    case gameOver
}

/// Service for managing game state transitions and retrieval.
///
/// Provides a domain-level API for transitioning between game states
/// and querying the current state. Delegates persistence to an adapter.
internal protocol GameStateService {
    /// Transitions the game to the playing state.
    func transitionToPlaying()

    /// Retrieves the current game state.
    /// - Returns: The current game state.
    func getState() -> GameState
}

internal struct RealGameStateService: GameStateService {
    private let adapter: GameStateAdapter

    internal init(adapter: GameStateAdapter) {
        self.adapter = adapter
    }

    internal func transitionToPlaying() {
        adapter.save(.playing)
    }

    internal func getState() -> GameState {
        adapter.read()
    }

}

/// Adapter for persisting and retrieving game state.
///
/// Abstracts the storage mechanism (in-memory, UserDefaults, etc.)
/// from the domain layer.
internal protocol GameStateAdapter {
    /// Persists the given game state.
    /// - Parameter state: The state to save.
    func save(_ state: GameState)

    /// Retrieves the current game state from storage.
    /// - Returns: The current game state.
    func read() -> GameState
}
