import SpriteKit

internal struct PaddleBounceApplier {
    private let calculator = PaddleBounceCalculator()

    internal func applyBounce(ball: SKNode, paddle: SKNode) {
        guard let ballBody = ball.physicsBody else { return }

        let currentVelocity = ballBody.velocity
        let ballSpeed = sqrt(currentVelocity.dx * currentVelocity.dx +
                           currentVelocity.dy * currentVelocity.dy)
        let paddleWidth = paddle.frame.width

        let newVelocity = calculator.calculateBounceVelocity(
            ballX: ball.position.x,
            paddleX: paddle.position.x,
            paddleWidth: paddleWidth,
            ballSpeed: ballSpeed
        )

        ballBody.velocity = newVelocity
    }
}
