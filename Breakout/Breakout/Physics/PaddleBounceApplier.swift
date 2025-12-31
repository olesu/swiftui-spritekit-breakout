import SpriteKit

struct PaddleBounceApplier {
    private let bounceSpeedPolicy: BounceSpeedPolicy
    private let bounceCalculator: BounceCalculator

    init(
        bounceSpeedPolicy: BounceSpeedPolicy,
        bounceCalculator: BounceCalculator
    ) {
        self.bounceSpeedPolicy = bounceSpeedPolicy
        self.bounceCalculator = bounceCalculator
    }

    func applyBounce(ball: BallSprite, paddle: PaddleSprite) {
        let currentVelocity = ball.velocity
        let ballSpeed = sqrt(
            currentVelocity.dx * currentVelocity.dx + currentVelocity.dy
                * currentVelocity.dy
        )
        let newVelocity = bounceSpeedPolicy.apply(
            to: bounceCalculator.calculateBounce(
                ballX: ball.position.x,
                paddleX: paddle.position.x,
                paddleWidth: paddle.size.width,
                ballSpeed: ballSpeed
            )
        )

        ball.setVelocity(newVelocity)
    }
}
