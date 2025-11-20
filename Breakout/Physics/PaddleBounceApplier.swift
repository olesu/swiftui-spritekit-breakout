import SpriteKit

internal struct PaddleBounceApplier {
    private let calculator = PaddleBounceCalculator()

    internal func applyBounce(ball: SKNode, paddle: SKNode) {
        guard let ballBody = ball.physicsBody,
              let paddleBody = paddle.physicsBody else { return }

        let currentVelocity = ballBody.velocity
        let ballSpeed = sqrt(currentVelocity.dx * currentVelocity.dx +
                           currentVelocity.dy * currentVelocity.dy)
        let paddleWidth = paddleBody.area / 8

        let newVelocity = calculator.calculateBounceVelocity(
            ballX: ball.position.x,
            paddleX: paddle.position.x,
            paddleWidth: paddleWidth,
            ballSpeed: ballSpeed
        )

        ballBody.velocity = newVelocity
    }
}
