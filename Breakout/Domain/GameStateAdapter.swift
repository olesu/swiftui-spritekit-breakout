import Foundation

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
