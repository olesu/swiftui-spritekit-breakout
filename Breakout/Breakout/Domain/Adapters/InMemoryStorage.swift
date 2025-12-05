import Foundation

/// In-memory storage for game state.
@Observable internal final class InMemoryStorage {
    internal var status = GameStatus.idle
    internal var gameResultDidWin = false
    internal var gameResultScore = 0
}
