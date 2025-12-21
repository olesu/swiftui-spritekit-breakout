import Foundation
import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct DefaultNodeManagerPaddleMovementTest {
    let sceneSize = CGSize(width: 100, height: 100)
    let paddlePosition = CGPoint(x: 10, y: 0)
    let paddleSize = CGSize(width: 2, height: 20)
    let paddleMotionController = PaddleMotionController(speed: 1)
    let ball = BallSprite(position: .zero)

    @Test func controlsThePaddleByMovingLeft() {
        let paddle = PaddleSprite(position: paddlePosition, size: paddleSize)
        let nodeManager = makeManager(paddle)

        nodeManager.startPaddleLeft()
        nodeManager.updatePaddleAndClampedBall(deltaTime: 1.0, sceneSize: sceneSize)
        nodeManager.stopPaddle()
        nodeManager.updatePaddleAndClampedBall(deltaTime: 1.0, sceneSize: sceneSize)

        #expect(paddle.position.x == 9.0)
    }

    @Test func controlsThePaddleByMovingRight() {
        let paddle = PaddleSprite(position: paddlePosition, size: paddleSize)
        let nodeManager = makeManager(paddle)

        nodeManager.startPaddleRight()
        nodeManager.updatePaddleAndClampedBall(deltaTime: 1.0, sceneSize: sceneSize)
        nodeManager.stopPaddle()
        nodeManager.updatePaddleAndClampedBall(deltaTime: 1.0, sceneSize: sceneSize)

        #expect(paddle.position.x == 11.0)
    }

    @Test func movingToAFixedPointOverridesKeyMovement() {
        let paddle = PaddleSprite(position: paddlePosition, size: paddleSize)
        let nodeManager = makeManager(paddle)

        // keyboard movement
        nodeManager.startPaddleRight()
        nodeManager.updatePaddleAndClampedBall(deltaTime: 1.0, sceneSize: sceneSize)
        #expect(nodeManager.paddle.position.x == 11.0)

        // drag override
        nodeManager.movePaddle(to: CGPoint(x: 3.0, y: 999), sceneSize: sceneSize)
        nodeManager.updatePaddleAndClampedBall(deltaTime: 1.0, sceneSize: sceneSize)
        #expect(nodeManager.paddle.position.x == 3.0)

        // resume keyboard
        nodeManager.endPaddleOverride()
        nodeManager.updatePaddleAndClampedBall(deltaTime: 1.0, sceneSize: sceneSize)
        #expect(paddle.position.x == 4.0)
    }
    
    private func makeManager(_ paddle: PaddleSprite) -> DefaultNodeManager {
        DefaultNodeManager(
            ballLaunchController: BallLaunchController(),
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: PaddleBounceApplier(),
            brickLayoutFactory: FakeBrickLayoutFactory(),
            paddle: paddle,
            ball: ball
        )
    }

}
