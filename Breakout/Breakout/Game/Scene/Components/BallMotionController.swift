import SpriteKit

struct BallMotionController {
    func update(ball: SKSpriteNode, speedMultiplier: CGFloat) {
        ball.physicsBody?.velocity.dx *= speedMultiplier
        ball.physicsBody?.velocity.dy *= speedMultiplier
    }
}
