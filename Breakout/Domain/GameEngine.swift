import Foundation

/// Core abstraction for the Breakout game engine.
///
/// The game engine processes events from the SpriteKit layer and maintains
/// game state including score, lives, and brick status. It enforces game rules
/// and determines win/lose conditions.
///
/// Event flow: SpriteKit detects collision → sends GameEvent → engine updates state
internal protocol GameEngine {
    /// The player's current score based on bricks destroyed.
    var currentScore: Int { get }

    /// The number of lives remaining for the player.
    var remainingLives: Int { get }

    /// Indicates whether the ball needs to be reset (after losing a life).
    var shouldResetBall: Bool { get }

    /// Starts the game, transitioning from idle to playing state.
    func start()

    /// Processes a game event from the SpriteKit layer.
    /// - Parameter event: The event to process (brick hit, ball lost, etc.)
    func process(event: GameEvent)

    /// Acknowledges that the ball has been reset, clearing the reset flag.
    func acknowledgeBallReset()
}
