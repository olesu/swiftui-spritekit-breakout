import SpriteKit

final class BallLaunchController {
    private let launchVector = Vector(dx: 0, dy: 400)

    private(set) var state: BallState = .clamped

    func clamp(ball: BallSprite, to paddle: PaddleSprite) {
        state = .clamped

        ball.setVelocity(.zero)
        ball.setPosition(Point(
            x: paddle.position.x,
            y: topOf(paddle: paddle) + ball.radius,
        ))
    }
    
    private func topOf(paddle: PaddleSprite) -> Double {
        paddle.position.y + paddle.size.height / 2
    }
    
    func launch(ball: BallSprite) {
        state = .launched
        ball.setVelocity(launchVector)
    }

    func reset(ball: BallSprite, onto paddle: PaddleSprite) {
        clamp(ball: ball, to: paddle)
    }

    func update(ball: BallSprite, paddle: PaddleSprite) {
        guard state == .clamped else { return }
        clamp(ball: ball, to: paddle)
    }

    func prepareReset(ball: BallSprite) {
        ball.hide()
    }

    func performReset(ball: BallSprite, at resetPosition: Point) {
        state = .clamped
        ball.setPosition(resetPosition)
        ball.setVelocity(.zero)
        ball.show()
    }

    func performWorldReset(ball: BallSprite, at position: Point) {
        state = .launched
        ball.setPosition(position)
        ball.show()
    }

    func performPaddleReset(ball: BallSprite, paddle: PaddleSprite) {
        state = .clamped
        clamp(ball: ball, to: paddle)
        ball.show()
    }
}
