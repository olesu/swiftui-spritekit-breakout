import Testing
import SpriteKit
@testable import Breakout

@Suite("PaddleBounceApplier Tests")
struct PaddleBounceApplierTest {

    @Test("Applies correct velocity for center hit") @MainActor
    func appliesCorrectVelocityForCenterHit() {
        let ball = SKSpriteNode()
        ball.position = CGPoint(x: 160, y: 50)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        ball.physicsBody?.velocity = CGVector(dx: 200, dy: -300)

        let paddle = SKSpriteNode()
        paddle.position = CGPoint(x: 160, y: 40)
        let paddleSize = CGSize(width: 40, height: 8)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddleSize)

        let applier = PaddleBounceApplier()
        applier.applyBounce(ball: ball, paddle: paddle)

        // Center hit should have minimal horizontal component
        let dx = ball.physicsBody?.velocity.dx ?? 0
        let dy = ball.physicsBody?.velocity.dy ?? 0

        #expect(abs(dx) < 50)
        #expect(dy > 0)  // Should bounce upward
    }

    @Test("Applies correct velocity for left edge hit") @MainActor
    func appliesCorrectVelocityForLeftEdgeHit() {
        let ball = SKSpriteNode()
        ball.position = CGPoint(x: 140, y: 50)  // Left of paddle center
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        ball.physicsBody?.velocity = CGVector(dx: 100, dy: -300)

        let paddle = SKSpriteNode()
        paddle.position = CGPoint(x: 160, y: 40)
        let paddleSize = CGSize(width: 40, height: 8)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddleSize)

        let applier = PaddleBounceApplier()
        applier.applyBounce(ball: ball, paddle: paddle)

        let dx = ball.physicsBody?.velocity.dx ?? 0
        let dy = ball.physicsBody?.velocity.dy ?? 0

        #expect(dx < 0)  // Should bounce left
        #expect(dy > 0)  // Should bounce upward
    }

    @Test("Applies correct velocity for right edge hit") @MainActor
    func appliesCorrectVelocityForRightEdgeHit() {
        let ball = SKSpriteNode()
        ball.position = CGPoint(x: 180, y: 50)  // Right of paddle center
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        ball.physicsBody?.velocity = CGVector(dx: -100, dy: -300)

        let paddle = SKSpriteNode()
        paddle.position = CGPoint(x: 160, y: 40)
        let paddleSize = CGSize(width: 40, height: 8)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddleSize)

        let applier = PaddleBounceApplier()
        applier.applyBounce(ball: ball, paddle: paddle)

        let dx = ball.physicsBody?.velocity.dx ?? 0
        let dy = ball.physicsBody?.velocity.dy ?? 0

        #expect(dx > 0)  // Should bounce right
        #expect(dy > 0)  // Should bounce upward
    }

    @Test("Handles missing physics bodies gracefully") @MainActor
    func handlesMissingPhysicsBodies() {
        let ball = SKSpriteNode()
        let paddle = SKSpriteNode()

        let applier = PaddleBounceApplier()

        // Should not crash when ball has no physics body
        applier.applyBounce(ball: ball, paddle: paddle)

        // Should not crash when only ball has physics body
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        applier.applyBounce(ball: ball, paddle: paddle)

        // Should not crash when only paddle has physics body
        ball.physicsBody = nil
        paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 8))
        applier.applyBounce(ball: ball, paddle: paddle)
    }
}
