import Foundation

/// Represents the current status of the game session.
internal enum GameStatus {
    /// Game is idle, waiting to start.
    case idle
    /// Game is actively being played.
    case playing
    /// Player has won by destroying all bricks.
    case won
    /// Player has lost all lives.
    case gameOver
}
