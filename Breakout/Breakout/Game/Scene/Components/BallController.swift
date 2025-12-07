import SpriteKit

final class BallController {
    private(set) var state: BallState = .clamped

    func clamp(ball: SKSpriteNode, to paddle: SKSpriteNode) {
        state = .clamped

        ball.physicsBody?.velocity = .zero
        ball.position.x = paddle.position.x

        let paddleTop = paddle.position.y + paddle.size.height / 2
        let ballRadius = ball.size.width / 2

        ball.position.y = paddleTop + ballRadius
    }

    func launch(ball: SKSpriteNode) {
        state = .launched

        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 400)
    }

    func reset(ball: SKSpriteNode, onto paddle: SKSpriteNode) {
        clamp(ball: ball, to: paddle)
    }

    func update(ball: SKSpriteNode, paddle: SKSpriteNode) {
        guard state == .clamped else { return }
        clamp(ball: ball, to: paddle)
    }

    func prepareReset(ball: SKSpriteNode) {
        let disabledMask: UInt32 = 0x0

        ball.physicsBody?.categoryBitMask = disabledMask
        ball.physicsBody?.contactTestBitMask = disabledMask
        ball.physicsBody?.collisionBitMask = disabledMask
        ball.alpha = 0
    }

    func performReset(ball: SKSpriteNode, at resetPosition: CGPoint) {
        state = .clamped
        
        ball.position = resetPosition

        ball.physicsBody?.velocity = .zero
        ball.physicsBody?.angularVelocity = 0
        restorePhysicsMasks(ball)
        ball.alpha = 1
    }
    
    private func restorePhysicsMasks(_ ball: SKSpriteNode) {
        ball.physicsBody?.categoryBitMask = CollisionCategory.ball.mask
        ball.physicsBody?.contactTestBitMask =
            CollisionCategory.wall.mask
            | CollisionCategory.gutter.mask
            | CollisionCategory.brick.mask
            | CollisionCategory.paddle.mask
        ball.physicsBody?.collisionBitMask =
            CollisionCategory.wall.mask
            | CollisionCategory.brick.mask
            | CollisionCategory.paddle.mask

    }
    
    func performWorldReset(ball: SKSpriteNode, at position: CGPoint) {
        state = .launched
        ball.position = position
        ball.physicsBody?.velocity = .zero
        ball.physicsBody?.angularVelocity = 0
        restorePhysicsMasks(ball)
        ball.alpha = 1
    }
    
    func performPaddleReset(ball: SKSpriteNode, paddle: SKSpriteNode) {
        state = .clamped
        ball.physicsBody?.velocity = .zero
        ball.physicsBody?.angularVelocity = 0
        
        clamp(ball: ball, to: paddle)
        
        restorePhysicsMasks(ball)
        ball.alpha = 1
    }
}
