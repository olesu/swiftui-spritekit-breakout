import Foundation

struct BounceCalculator {
    func calculateBounce(
        ballX: Double,
        paddleX: Double,
        paddleWidth: Double,
        ballSpeed: Double
    ) -> Vector {
        // Calculate where on paddle the ball hit (-1.0 to 1.0, center = 0)
        let rawIntersectX = (ballX - paddleX) / (paddleWidth / 2)

        // Clamp to paddle bounds to prevent extreme angles
        let relativeIntersectX = max(-1.0, min(1.0, rawIntersectX))

        // Maximum bounce angle: 45 degrees from vertical
        let maxBounceAngle = Double.pi / 4  // 45 degrees in radians
        let bounceAngle = relativeIntersectX * maxBounceAngle

        // Calculate velocity components
        let dx = ballSpeed * sin(bounceAngle)
        let dy = ballSpeed * cos(bounceAngle)

        return Vector(dx: dx, dy: dy)
    }
}
