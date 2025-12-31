import SpriteKit

final class BallLaunchController {
    private let launchVector = Vector(dx: 0, dy: 400)
    private let disabledMask: UInt32 = 0x0

    private(set) var state: BallState = .clamped

    func clamp(ball: BallSprite, to paddle: SKSpriteNode) {
        state = .clamped

        ball.setVelocity(.zero)
        ball.setPosition(Point(
            x: paddle.position.x,
            y: topOf(paddle: paddle) + ball.radius,
        ))
    }
    
    private func topOf(paddle: SKSpriteNode) -> CGFloat {
        paddle.position.y + paddle.size.height / 2
    }
    
    func launch(ball: BallSprite) {
        state = .launched
        ball.setVelocity(launchVector)
    }

    func reset(ball: BallSprite, onto paddle: SKSpriteNode) {
        clamp(ball: ball, to: paddle)
    }

    func update(ball: BallSprite, paddle: SKSpriteNode) {
        guard state == .clamped else { return }
        clamp(ball: ball, to: paddle)
    }

    func prepareReset(ball: BallSprite) {
        ball.node.physicsBody?.categoryBitMask = disabledMask
        ball.node.physicsBody?.contactTestBitMask = disabledMask
        ball.node.physicsBody?.collisionBitMask = disabledMask
        ball.node.alpha = 0
    }

    func performReset(ball: BallSprite, at resetPosition: Point) {
        state = .clamped
        ball.setPosition(resetPosition)
        ball.node.alpha = 1
        ball.setVelocity(.zero)
        ball.node.physicsBody?.angularVelocity = 0
        restorePhysicsMasks(ball)
    }

    private func restorePhysicsMasks(_ ball: BallSprite) {
        ball.node.physicsBody?.categoryBitMask = CollisionCategory.ball.mask
        ball.node.physicsBody?.contactTestBitMask =
            CollisionCategory.wall.mask
            | CollisionCategory.gutter.mask
            | CollisionCategory.brick.mask
            | CollisionCategory.paddle.mask
        ball.node.physicsBody?.collisionBitMask =
            CollisionCategory.wall.mask
            | CollisionCategory.brick.mask
            | CollisionCategory.paddle.mask

    }

    func performWorldReset(ball: BallSprite, at position: Point) {
        state = .launched
        ball.setPosition(position)
        ball.node.alpha = 1
        ball.setVelocity(.zero)
        ball.node.physicsBody?.angularVelocity = 0
        restorePhysicsMasks(ball)
    }

    func performPaddleReset(ball: BallSprite, paddle: SKSpriteNode) {
        state = .clamped
        ball.node.alpha = 1
        ball.setVelocity(.zero)
        ball.node.physicsBody?.angularVelocity = 0
        clamp(ball: ball, to: paddle)
        restorePhysicsMasks(ball)
    }
}
