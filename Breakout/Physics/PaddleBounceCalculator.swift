import Foundation

struct PaddleBounceCalculator {
    func calculateBounceVelocity(
        ballX: CGFloat,
        paddleX: CGFloat,
        paddleWidth: CGFloat,
        ballSpeed: CGFloat
    ) -> CGVector {
        // Calculate where on paddle the ball hit (-1.0 to 1.0, center = 0)
        let rawIntersectX = (ballX - paddleX) / (paddleWidth / 2)

        // Clamp to paddle bounds to prevent extreme angles
        let relativeIntersectX = max(-1.0, min(1.0, rawIntersectX))

        // Maximum bounce angle: 60 degrees from vertical
        let maxBounceAngle = CGFloat.pi / 3  // 60 degrees in radians
        let bounceAngle = relativeIntersectX * maxBounceAngle

        // Calculate velocity components
        let dx = ballSpeed * sin(bounceAngle)
        let dy = ballSpeed * cos(bounceAngle)

        return CGVector(dx: dx, dy: dy)
    }
}
