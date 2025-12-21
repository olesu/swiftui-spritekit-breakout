import SpriteKit

struct PaddleBounceApplier {
    private let speedMultiplier = 1.03
    
    private let calculator = PaddleBounceCalculator()

    func applyBounce(ball: SKNode, paddle: SKNode) {
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

        ballBody.velocity.dx = newVelocity.dx * speedMultiplier
        ballBody.velocity.dy = newVelocity.dy * speedMultiplier
    }
}
