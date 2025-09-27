import Foundation

struct AutoPaddleConfig {
    let paddleSpeed: CGFloat = 450.0
    let jitterRangeX: ClosedRange<CGFloat> = (-18.0)...(18.0)
    let reactionTimeRange: ClosedRange<CGFloat> = 0.0...0.09
    let skipMoveProbability: CGFloat = 0.03
}

struct AutoPaddle {
    let paddle: PaddleSprite
    let ball: BallSprite

    // Tuning parameters for imperfect auto play
    let paddleSpeed: CGFloat
    let jitterRangeX: ClosedRange<CGFloat>
    let reactionTimeRange: ClosedRange<CGFloat>
    let skipMoveProbability: CGFloat

    init(
        paddle: PaddleSprite,
        ball: BallSprite,
        paddleSpeed: CGFloat = 450,
        jitterRangeX: ClosedRange<CGFloat> = (-18)...(18),
        reactionTimeRange: ClosedRange<CGFloat> = 0.0...0.09,
        skipMoveProbability: CGFloat = 0.03
    ) {
        self.paddle = paddle
        self.ball = ball
        self.paddleSpeed = paddleSpeed
        self.jitterRangeX = jitterRangeX
        self.reactionTimeRange = reactionTimeRange
        self.skipMoveProbability = skipMoveProbability
    }
    
    init(paddle: PaddleSprite, ball: BallSprite, config: AutoPaddleConfig) {
        self.paddle = paddle
        self.ball = ball
        self.paddleSpeed = config.paddleSpeed
        self.jitterRangeX = config.jitterRangeX
        self.reactionTimeRange = config.reactionTimeRange
        self.skipMoveProbability = config.skipMoveProbability

    }
    
    func move() {
        guard let ballPhysics = ball.physicsBody else { return }
        let ballVelocity = ballPhysics.velocity
        
        // Occasionally skip movement to simulate hesitation
        if Double.random(in: 0...1) < Double(skipMoveProbability) {
            return
        }

        // Only move paddle if ball is moving downward
        if ballVelocity.dy < 0 {
            // Calculate where ball will be when it reaches paddle y-level,
            // but add a small reaction delay and horizontal jitter to make it imperfect
            let timeToReachPaddle = (ball.position.y - paddle.position.y) / abs(ballVelocity.dy)
            let reactionDelay = CGFloat.random(in: reactionTimeRange)
            let predictedTime = timeToReachPaddle + reactionDelay
            let futureX = ball.position.x + (ballVelocity.dx * predictedTime)
            let jitterX = CGFloat.random(in: jitterRangeX)
            
            // Move paddle towards a slightly noisy target position
            let targetX = max(30, min(290, futureX + jitterX)) // Keep paddle within bounds
            let currentX = paddle.position.x
            
            if abs(targetX - currentX) > 5 {
                let direction = targetX > currentX ? 1 : -1
                let newX = currentX + (CGFloat(direction) * paddleSpeed * 1/60) // Assuming 60 FPS
                paddle.position.x = max(30, min(290, newX))
            }
        }
    }
}

