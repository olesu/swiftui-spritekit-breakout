import SpriteKit
import Testing

@testable import Breakout

struct PaddleBounceApplierTest {
    private let bounceSpeedPolicy = GameTuning.testNeutral.bounceSpeedPolicy
    private let bounceCalculator = BounceCalculator()

    @Test
    func appliesCorrectVelocityForCenterHit() {
        let ball = makeBall()
        let paddle = makePaddle()
        let _ = makeApplier(ball, paddle)

        // Center hit should have minimal horizontal component
        let dx = ball.velocity.dx
        let dy = ball.velocity.dy

        #expect(abs(dx) < 50)
        #expect(dy > 0)  // Should bounce upward
    }

    @Test
    func appliesCorrectVelocityForLeftEdgeHit() {
        let ball = makeBall()
        ball.setPosition(Point(x: 140, y: ball.position.y))  // Left of paddle center
        let paddle = makePaddle()
        let _ = makeApplier(ball, paddle)

        let dx = ball.velocity.dx
        let dy = ball.velocity.dy

        #expect(dx < 0)  // Should bounce left
        #expect(dy > 0)  // Should bounce upward
    }

    @Test
    func appliesCorrectVelocityForRightEdgeHit() {
        let ball = makeBall()
        ball.setPosition(Point(x: 180, y: ball.position.y))  // Right of paddle center
        let paddle = makePaddle()
        let _ = makeApplier(ball, paddle)

        let dx = ball.velocity.dx
        let dy = ball.velocity.dy

        #expect(dx > 0)  // Should bounce right
        #expect(dy > 0)  // Should bounce upward
    }

    @Test
    func handlesMissingPhysicsBodies() {
        let ball = SKBallSprite(position: .zero)
        let paddle = PaddleSprite(position: .zero, size: .zero)

        let applier = PaddleBounceApplier(
            bounceSpeedPolicy: bounceSpeedPolicy,
            bounceCalculator: bounceCalculator
        )

        // Should not crash when ball has no physics body
        applier.applyBounce(ball: ball, paddle: paddle)

        // Should not crash when only ball has physics body
        ball.node.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        applier.applyBounce(ball: ball, paddle: paddle)

        // Should not crash when only paddle has physics body
        ball.node.physicsBody = nil
        paddle.node.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: 40, height: 8)
        )
        applier.applyBounce(ball: ball, paddle: paddle)
    }

    private func makeBall() -> SKBallSprite {
        let ball = SKBallSprite(position: Point(x: 160, y: 50))
        ball.node.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        ball.setVelocity(Vector(dx: 200, dy: -300))

        return ball
    }

    private func makePaddle() -> PaddleSprite {
        let paddleSize = Size(width: 40, height: 8)
        let paddle = PaddleSprite(position: Point(x: 160, y: 40), size: paddleSize)
        paddle.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(paddleSize))

        return paddle
    }

    private func makeApplier(_ ball: SKBallSprite, _ paddle: PaddleSprite)
        -> PaddleBounceApplier
    {
        let applier = PaddleBounceApplier(
            bounceSpeedPolicy: bounceSpeedPolicy,
            bounceCalculator: bounceCalculator
        )
        applier.applyBounce(ball: ball, paddle: paddle)

        return applier
    }

}
