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
