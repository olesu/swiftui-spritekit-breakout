import Foundation

struct AutoPaddle {
    let paddle: PaddleSprite
    let ball: BallSprite

    init(paddle: PaddleSprite, ball: BallSprite) {
        self.paddle = paddle
        self.ball = ball
    }
    
    func move() {
        guard let ballPhysics = ball.physicsBody else { return }
        let ballVelocity = ballPhysics.velocity
        
        // Only move paddle if ball is moving downward
        if ballVelocity.dy < 0 {
            // Calculate where ball will be when it reaches paddle y-level
            let timeToReachPaddle = (ball.position.y - paddle.position.y) / abs(ballVelocity.dy)
            let futureX = ball.position.x + (ballVelocity.dx * timeToReachPaddle)
            
            // Move paddle towards predicted ball position
            let paddleSpeed: CGFloat = 450
            let targetX = max(30, min(290, futureX)) // Keep paddle within bounds
            let currentX = paddle.position.x
            
            if abs(targetX - currentX) > 5 {
                let direction = targetX > currentX ? 1 : -1
                let newX = currentX + (CGFloat(direction) * paddleSpeed * 1/60) // Assuming 60 FPS
                paddle.position.x = max(30, min(290, newX))
            }
        }
    }
}
