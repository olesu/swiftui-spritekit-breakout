import Foundation

/// Adapter for persisting and retrieving game state.
///
/// Abstracts the storage mechanism (in-memory, UserDefaults, etc.)
/// from the domain layer.
internal protocol GameStatusAdapter {
    /// Persists the given game status.
    /// - Parameter status: The status to save.
    func save(_ status: GameStatus)

    /// Retrieves the current game status from storage.
    /// - Returns: The current game status.
    func read() -> GameStatus
}
