import SpriteKit
import Testing

@testable import Breakout

struct BallMotionControllerTest {

    @MainActor
    struct BallControllerAccelerationTest {

        @Test func update_appliesMultiplierProvidedToUpdate() {
            let controller = TD.ballController()
            let ball = TD.ball()

            controller.update(
                ball: ball,
                speedMultiplier: 1.5
            )

            #expect(ball.physicsBody?.velocity.dx == 150)
            #expect(ball.physicsBody?.velocity.dy == 300)
        }
    }

}

private enum TD {
    static func ballController() -> BallMotionController {
        BallMotionController()
    }

    static func ball() -> SKSpriteNode {
        let ball = SKSpriteNode(
            color: .white,
            size: CGSize(width: 20, height: 20)
        )
        ball.physicsBody = ballPhysicsBody()
        return ball
    }

    private static func ballPhysicsBody() -> SKPhysicsBody {
        let pb = SKPhysicsBody(circleOfRadius: 10)
        pb.velocity = .init(dx: 100, dy: 200)
        
        return pb
    }
}

