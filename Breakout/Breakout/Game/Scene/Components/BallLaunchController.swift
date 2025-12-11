import SpriteKit

final class BallLaunchController {
    private let launchVector = CGVector(dx: 0, dy: 400)
    private let disabledMask: UInt32 = 0x0

    private(set) var state: BallState = .clamped

    func clamp(ball: SKSpriteNode, to paddle: SKSpriteNode) {
        state = .clamped

        ball.physicsBody?.velocity = .zero
        ball.position.x = paddle.position.x
        ball.position.y = topOf(paddle: paddle) + radiusOf(ball: ball)
    }
    
    private func topOf(paddle: SKSpriteNode) -> CGFloat {
        paddle.position.y + paddle.size.height / 2
    }
    
    private func radiusOf(ball: SKSpriteNode) -> CGFloat {
        ball.size.width / 2
    }

    func launch(ball: SKSpriteNode) {
        state = .launched
        ball.physicsBody?.velocity = launchVector
    }

    func reset(ball: SKSpriteNode, onto paddle: SKSpriteNode) {
        clamp(ball: ball, to: paddle)
    }

    func update(ball: SKSpriteNode, paddle: SKSpriteNode) {
        guard state == .clamped else { return }
        clamp(ball: ball, to: paddle)
    }

    func prepareReset(ball: SKSpriteNode) {
        ball.physicsBody?.categoryBitMask = disabledMask
        ball.physicsBody?.contactTestBitMask = disabledMask
        ball.physicsBody?.collisionBitMask = disabledMask
        ball.alpha = 0
    }

    func performReset(ball: SKSpriteNode, at resetPosition: CGPoint) {
        state = .clamped
        ball.position = resetPosition
        ball.alpha = 1
        ball.physicsBody?.velocity = .zero
        ball.physicsBody?.angularVelocity = 0
        restorePhysicsMasks(ball)
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
        ball.alpha = 1
        ball.physicsBody?.velocity = .zero
        ball.physicsBody?.angularVelocity = 0
        restorePhysicsMasks(ball)
    }

    func performPaddleReset(ball: SKSpriteNode, paddle: SKSpriteNode) {
        state = .clamped
        ball.alpha = 1
        ball.physicsBody?.velocity = .zero
        ball.physicsBody?.angularVelocity = 0
        clamp(ball: ball, to: paddle)
        restorePhysicsMasks(ball)
    }
}
