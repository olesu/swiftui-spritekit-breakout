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

    func applyBounce(ball: SKNode, paddle: SKNode) {
        guard let ballBody = ball.physicsBody else { return }

        let currentVelocity = ballBody.velocity
        let ballSpeed = sqrt(
            currentVelocity.dx * currentVelocity.dx + currentVelocity.dy
                * currentVelocity.dy
        )
        let paddleWidth = paddle.frame.width

        let newVelocity = bounceSpeedPolicy.apply(
            to: bounceCalculator.calculateBounce(
                ballX: ball.position.x,
                paddleX: paddle.position.x,
                paddleWidth: paddleWidth,
                ballSpeed: ballSpeed
            )
        )

        ballBody.velocity = CGVector(newVelocity)
    }
}

extension CGVector {
    init(_ velocity: Velocity) {
        self.init(dx: CGFloat(velocity.dx), dy: CGFloat(velocity.dy))
    }
}
