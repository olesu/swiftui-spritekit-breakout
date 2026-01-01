import SpriteKit
import Testing

@testable import Breakout

struct BallLaunchControllerTest {
    private let tolerance = 0.001
    let controller = TD.ballLaunchController()
    let paddle = TD.paddle()
    let ball = TD.ball()


    @Test func clampsBallCenteredAboveThePaddle() {
        paddle.setPosition(TD.paddleStartPosition())

        controller.clamp(ball: ball, to: paddle)

        #expect(abs(ball.position.x - paddle.position.x) < tolerance)
        #expect(abs(ball.position.y - expectedY(ball, paddle)) < tolerance)
    }

    @Test func launchesBallWithUpwardVelocity() {
        controller.launch(ball: ball)

        #expect(ball.node.physicsBody != nil)
        #expect(ball.node.physicsBody!.velocity.dx == 0)
        #expect(ball.node.physicsBody!.velocity.dy > 0)
    }

    @Test func resetClampsBallToThePaddle() {
        paddle.setPosition(TD.paddleStartPosition())

        ball.setPosition(Point(x: 999, y: 999))

        controller.reset(ball: ball, onto: paddle)

        #expect(
            ball.position
                == Point(
                    x: paddle.position.x,
                    y: expectedY(ball, paddle)
                )
        )
    }
    
    @Test func clampStopsBallMovement() {
        ball.setVelocity(Vector(dx: 10, dy: 10))
        
        controller.clamp(ball: ball, to: TD.paddle())
        
        #expect(ball.velocity == Vector.zero)
    }
    
    @Test func clampedBallFollowsPaddle() {
        paddle.setPosition(TD.paddleStartPosition())
        
        controller.clamp(ball: ball, to: paddle)
        
        paddle.setPosition(Point(x: paddle.position.x + 30, y: paddle.position.y))
        
        controller.update(ball: ball, paddle: paddle)
        
        #expect(abs(ball.position.x - paddle.position.x) < tolerance)
        #expect(abs(ball.position.y - expectedY(ball, paddle)) < tolerance)
    }
    
    @Test func launchedBallDoesNotFollowPaddle() {
        paddle.setPosition(TD.paddleStartPosition())
        
        controller.clamp(ball: ball, to: paddle)
        controller.launch(ball: ball)
        
        let oldPosition = ball.position
        
        paddle.setPosition(Point(x: paddle.position.x + 50, y: paddle.position.y))
        
        controller.update(ball: ball, paddle: paddle)
        
        #expect(ball.position == oldPosition)
    }
    
    @Test func prepareResetDisablesPhysicsAndHidesBall() {
        controller.prepareReset(ball: ball)
        
        #expect(ball.node.physicsBody?.categoryBitMask == 0)
        #expect(ball.node.physicsBody?.contactTestBitMask == 0)
        #expect(ball.node.physicsBody?.collisionBitMask == 0)
        #expect(ball.node.alpha == 0)
    }
    
    @Test func performResetRestoresPhysicsAndVisibility() {
        ball.setVelocity(Vector(dx: 123, dy: -456))
        ball.node.physicsBody?.angularVelocity = .pi
        
        controller.prepareReset(ball: ball)
        
        let resetPosition = Point(x: 160, y: 50)
        controller.performReset(ball: ball, at: resetPosition)
        
        #expect(ball.velocity == .zero)
        #expect(ball.node.physicsBody?.angularVelocity == 0)
        #expect(ball.position == resetPosition)
        
        #expect(ball.node.physicsBody?.categoryBitMask == CollisionCategory.ball.mask)
        #expect(ball.node.physicsBody?.contactTestBitMask ==
                CollisionCategory.wall.mask
                | CollisionCategory.gutter.mask
                | CollisionCategory.brick.mask
                | CollisionCategory.paddle.mask
        )
        #expect(ball.node.physicsBody?.collisionBitMask ==
                CollisionCategory.wall.mask
                | CollisionCategory.brick.mask
                | CollisionCategory.paddle.mask
        )
        #expect(ball.node.alpha == 1)
    }
    
    @Test func performResetSetsStateToClamped() {
        controller.launch(ball: ball)
        controller.prepareReset(ball: ball)
        controller.performReset(ball: ball, at: Point(x: 160, y: 50))
        
        #expect(controller.state == .clamped)
    }
    
    @Test func performResetClampsBallAndFollowsPaddle() {
        let paddle = TD.paddle()

        controller.launch(ball: ball)
        controller.prepareReset(ball: ball)
        controller.performReset(ball: ball, at: Point(x: 160, y: 50))

        // Move paddle
        paddle.setPosition(Point(x: paddle.position.x + 30, y: paddle.position.y))

        controller.update(ball: ball, paddle: paddle)

        #expect(abs(ball.position.x - paddle.position.x) < tolerance)
    }

    @Test func performWorldResetDoesNotClampBall() {
        controller.prepareReset(ball: ball)

        let position = Point(x: 200, y: 200)
        controller.performWorldReset(ball: ball, at: position)

        // Correct expectation: world reset means "ball is free", not clamped
        #expect(controller.state == .launched)

        // Move paddle
        paddle.setPosition(Point(x: paddle.position.x + 50, y: paddle.position.y))
        controller.update(ball: ball, paddle: paddle)

        // Ball should stay at world reset position, not clamp to paddle
        #expect(ball.position == position)
    }

    @Test func performPaddleResetClampsBallToPaddle() {
        paddle.setPosition(TD.paddleStartPosition())

        controller.prepareReset(ball: ball)
        controller.performPaddleReset(ball: ball, paddle: paddle)

        #expect(abs(ball.position.x - paddle.position.x) < tolerance)
        #expect(abs(ball.position.y - expectedY(ball, paddle)) < tolerance)
        #expect(controller.state == .clamped)
    }

    @Test func performPaddleResetMakesBallFollowPaddle() {
        ball.node.physicsBody = TD.ballPhysicsBody()
        paddle.setPosition(TD.paddleStartPosition())

        controller.prepareReset(ball: ball)
        controller.performPaddleReset(ball: ball, paddle: paddle)

        // Move paddle
        paddle.setPosition(Point(x: paddle.position.x + 40, y: paddle.position.y))

        controller.update(ball: ball, paddle: paddle)

        #expect(abs(ball.position.x - paddle.position.x) < tolerance)
    }
    
    private func expectedY(_ ball: SKBallSprite, _ paddle: PaddleSprite) -> Double {
        paddle.position.y + paddle.size.height / 2 + ball.size
            .height / 2
    }
}

private enum TD {
    static func ballLaunchController() -> BallLaunchController {
        BallLaunchController()
    }

    static func ball() -> SKBallSprite {
        SKBallSprite(position: .zero)
    }

    static func paddle() -> PaddleSprite {
        PaddleSprite(
            position: .zero,
            size: Size(width: 100, height: 20)
        )
    }

    static func paddleStartPosition() -> Point {
        Point(x: 150, y: 40)
    }

    static func ballPhysicsBody() -> SKPhysicsBody {
        SKPhysicsBody(circleOfRadius: 10)
    }
}

