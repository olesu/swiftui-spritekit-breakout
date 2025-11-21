import Foundation

/// Events sent from the SpriteKit layer to the domain game engine.
///
/// Represents significant game occurrences detected by the physics engine
/// that require domain logic processing (score updates, life management, etc.).
internal enum GameEvent: Equatable {
    /// A brick was hit by the ball.
    /// - Parameter brickID: The unique identifier of the brick that was hit.
    case brickHit(brickID: UUID)

    /// The ball fell into the gutter (player lost a life).
    case ballLost
}
