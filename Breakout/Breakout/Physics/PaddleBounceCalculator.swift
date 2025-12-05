import Foundation

/// Calculates ball velocity after bouncing off the paddle.
///
/// Implements position-based bounce angle control to give players precise
/// control over ball direction. The angle varies based on where the ball
/// hits the paddle, with the center producing a straight vertical bounce
/// and the edges producing angled bounces.
internal struct PaddleBounceCalculator {
    /// Calculates the ball's velocity after bouncing off the paddle.
    ///
    /// The bounce angle is determined by the ball's position relative to the paddle center:
    /// - Center hit (0.0): Vertical bounce (0° from vertical)
    /// - Edge hits (±1.0): Maximum angle bounce (±45° from vertical)
    /// - Intermediate positions: Proportional angles between 0° and 45°
    ///
    /// The ball always bounces upward (positive dy) with the original speed maintained.
    ///
    /// - Parameters:
    ///   - ballX: The x-coordinate of the ball's position.
    ///   - paddleX: The x-coordinate of the paddle's center.
    ///   - paddleWidth: The width of the paddle.
    ///   - ballSpeed: The desired magnitude of the ball's velocity.
    /// - Returns: A velocity vector with magnitude equal to `ballSpeed` and direction
    ///            determined by the hit position.
    internal func calculateBounceVelocity(
        ballX: CGFloat,
        paddleX: CGFloat,
        paddleWidth: CGFloat,
        ballSpeed: CGFloat
    ) -> CGVector {
        // Calculate where on paddle the ball hit (-1.0 to 1.0, center = 0)
        let rawIntersectX = (ballX - paddleX) / (paddleWidth / 2)

        // Clamp to paddle bounds to prevent extreme angles
        let relativeIntersectX = max(-1.0, min(1.0, rawIntersectX))

        // Maximum bounce angle: 45 degrees from vertical
        let maxBounceAngle = CGFloat.pi / 4  // 45 degrees in radians
        let bounceAngle = relativeIntersectX * maxBounceAngle

        // Calculate velocity components
        let dx = ballSpeed * sin(bounceAngle)
        let dy = ballSpeed * cos(bounceAngle)

        return CGVector(dx: dx, dy: dy)
    }
}
