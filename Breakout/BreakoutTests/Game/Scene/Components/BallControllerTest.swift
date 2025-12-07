import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct BallControllerTest {

    @Test func clampsBallCenteredAboveThePaddle() {
        let controller = TD.ballController()
        let paddle = TD.paddle()
        let ball = TD.ball()

        paddle.position = TD.paddleStartPosition()

        controller.clamp(ball: ball, to: paddle)

        #expect(ball.position.x == paddle.position.x)
        #expect(ball.position.y == expectedY(ball, paddle))
    }

    @Test func launchesBallWithUpwardVelocity() {
        let controller = TD.ballController()
        let ball = TD.ball()

        ball.physicsBody = TD.ballPhysicsBody()

        controller.launch(ball: ball)

        #expect(ball.physicsBody != nil)
        #expect(ball.physicsBody!.velocity.dx == 0)
        #expect(ball.physicsBody!.velocity.dy > 0)
    }

    @Test func resetClampsBallToThePaddle() {
        let controller = TD.ballController()
        let ball = TD.ball()
        let paddle = TD.paddle()

        paddle.position = TD.paddleStartPosition()

        ball.position = CGPoint(x: 999, y: 999)

        controller.reset(ball: ball, onto: paddle)

        #expect(
            ball.position
                == CGPoint(
                    x: paddle.position.x,
                    y: expectedY(ball, paddle)
                )
        )
    }
    
    @Test func clampStopsBallMovement() {
        let controller = TD.ballController()
        let ball = TD.ball()
        
        ball.physicsBody = TD.ballPhysicsBody()
        ball.physicsBody?.velocity = CGVector(dx: 10, dy: 10)
        
        controller.clamp(ball: ball, to: TD.paddle())
        
        #expect(ball.physicsBody!.velocity == .zero)
    }
    
    @Test func clampedBallFollowsPaddle() {
        let controller = TD.ballController()
        let ball = TD.ball()
        let paddle = TD.paddle()

        paddle.position = TD.paddleStartPosition()
        ball.physicsBody = TD.ballPhysicsBody()
        
        controller.clamp(ball: ball, to: paddle)
        
        paddle.position.x += 30
        
        controller.update(ball: ball, paddle: paddle)
        
        #expect(ball.position.x == paddle.position.x)
        
        #expect(ball.position.y == expectedY(ball, paddle))
    }
    
    @Test func launchedBallDoesNotFollowPaddle() {
        let controller = TD.ballController()
        let ball = TD.ball()
        let paddle = TD.paddle()

        paddle.position = TD.paddleStartPosition()
        ball.physicsBody = TD.ballPhysicsBody()
        
        controller.clamp(ball: ball, to: paddle)
        controller.launch(ball: ball)
        
        let oldPosition = ball.position
        
        paddle.position.x += 50
        
        controller.update(ball: ball, paddle: paddle)
        
        #expect(ball.position == oldPosition)
    }
    
    @Test func prepareResetDisablesPhysicsAndHidesBall() {
        let controller = TD.ballController()
        let ball = TD.ball()
        
        ball.physicsBody = TD.ballPhysicsBody()
        
        controller.prepareReset(ball: ball)
        
        #expect(ball.physicsBody?.categoryBitMask == 0)
        #expect(ball.physicsBody?.contactTestBitMask == 0)
        #expect(ball.physicsBody?.collisionBitMask == 0)
        #expect(ball.alpha == 0)
    }
    
    @Test func performResetRestoresPhysicsAndVisibility() {
        let controller = TD.ballController()
        let ball = TD.ball()
        
        ball.physicsBody = TD.ballPhysicsBody()
        ball.physicsBody?.velocity = CGVector(dx: 123, dy: -456)
        ball.physicsBody?.angularVelocity = .pi
        
        controller.prepareReset(ball: ball)
        
        let resetPosition = CGPoint(x: 160, y: 50)
        controller.performReset(ball: ball, at: resetPosition)
        
        #expect(ball.physicsBody?.velocity == .zero)
        #expect(ball.physicsBody?.angularVelocity == 0)
        #expect(ball.position == resetPosition)
        
        #expect(ball.physicsBody?.categoryBitMask == CollisionCategory.ball.mask)
        #expect(ball.physicsBody?.contactTestBitMask ==
                CollisionCategory.wall.mask
                | CollisionCategory.gutter.mask
                | CollisionCategory.brick.mask
                | CollisionCategory.paddle.mask
        )
        #expect(ball.physicsBody?.collisionBitMask ==
                CollisionCategory.wall.mask
                | CollisionCategory.brick.mask
                | CollisionCategory.paddle.mask
        )
        #expect(ball.alpha == 1)
    }
    
    @Test func performResetSetsStateToClamped() {
        let controller = TD.ballController()
        let ball = TD.ball()
        ball.physicsBody = TD.ballPhysicsBody()
        
        controller.launch(ball: ball)
        controller.prepareReset(ball: ball)
        controller.performReset(ball: ball, at: CGPoint(x: 160, y: 50))
        
        #expect(controller.state == .clamped)
    }
    
    @Test func performResetClampsBallAndFollowsPaddle() {
        let controller = TD.ballController()
        let ball = TD.ball()
        ball.physicsBody = TD.ballPhysicsBody()
        let paddle = TD.paddle()

        controller.launch(ball: ball)
        controller.prepareReset(ball: ball)
        controller.performReset(ball: ball, at: CGPoint(x: 160, y: 50))

        // Move paddle
        paddle.position.x += 30

        controller.update(ball: ball, paddle: paddle)

        #expect(ball.position.x == paddle.position.x)
    }

    @Test func performWorldResetDoesNotClampBall() {
        let controller = TD.ballController()
        let ball = TD.ball()
        let paddle = TD.paddle()

        ball.physicsBody = TD.ballPhysicsBody()

        controller.prepareReset(ball: ball)

        let position = CGPoint(x: 200, y: 200)
        controller.performWorldReset(ball: ball, at: position)

        // Correct expectation: world reset means "ball is free", not clamped
        #expect(controller.state == .launched)

        // Move paddle
        paddle.position.x += 50
        controller.update(ball: ball, paddle: paddle)

        // Ball should stay at world reset position, not clamp to paddle
        #expect(ball.position == position)
    }

    @Test func performPaddleResetClampsBallToPaddle() {
        let controller = TD.ballController()
        let ball = TD.ball()
        let paddle = TD.paddle()

        ball.physicsBody = TD.ballPhysicsBody()
        paddle.position = TD.paddleStartPosition()

        controller.prepareReset(ball: ball)
        controller.performPaddleReset(ball: ball, paddle: paddle)

        #expect(ball.position.x == paddle.position.x)
        #expect(ball.position.y == expectedY(ball, paddle))
        #expect(controller.state == .clamped)
    }

    @Test func performPaddleResetMakesBallFollowPaddle() {
        let controller = TD.ballController()
        let ball = TD.ball()
        let paddle = TD.paddle()
        
        ball.physicsBody = TD.ballPhysicsBody()
        paddle.position = TD.paddleStartPosition()

        controller.prepareReset(ball: ball)
        controller.performPaddleReset(ball: ball, paddle: paddle)

        // Move paddle
        paddle.position.x += 40

        controller.update(ball: ball, paddle: paddle)

        #expect(ball.position.x == paddle.position.x)
    }
    
    private func expectedY(_ ball: SKSpriteNode, _ paddle: SKSpriteNode) -> CGFloat {
        paddle.position.y + paddle.size.height / 2 + ball.size
            .height / 2
    }
}

private enum TD {
    static func ballController() -> BallController {
        BallController()
    }

    static func ball() -> SKSpriteNode {
        SKSpriteNode(
            color: .white,
            size: CGSize(width: 20, height: 20)
        )
    }

    static func paddle() -> SKSpriteNode {
        SKSpriteNode(
            color: .white,
            size: CGSize(width: 100, height: 20)
        )
    }

    static func paddleStartPosition() -> CGPoint {
        CGPoint(x: 150, y: 40)
    }

    static func ballPhysicsBody() -> SKPhysicsBody {
        SKPhysicsBody(circleOfRadius: 10)
    }
}

