import Foundation
import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct DefaultNodeManagerPaddleMovementTest {
    private let sceneSize = CGSize(width: 100, height: 100)
    private let paddlePosition = CGPoint(x: 10, y: 0)
    private let paddleSize = CGSize(width: 2, height: 20)
    private let paddleMotionController = PaddleMotionController(speed: 1)
    private let ball = BallSprite(position: .zero)

    @Test func controlsThePaddleByMovingLeft() {
        let paddle = PaddleSprite(position: paddlePosition, size: paddleSize)
        let nodeManager = makeManager(paddle)

        nodeManager.startPaddleLeft()
        nodeManager.update(
            deltaTime: 1.0,
            sceneSize: sceneSize
        )
        nodeManager.stopPaddle()
        nodeManager.update(
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        #expect(paddle.position.x == 9.0)
    }

    @Test func controlsThePaddleByMovingRight() {
        let paddle = PaddleSprite(position: paddlePosition, size: paddleSize)
        let nodeManager = makeManager(paddle)

        nodeManager.startPaddleRight()
        nodeManager.update(
            deltaTime: 1.0,
            sceneSize: sceneSize
        )
        nodeManager.stopPaddle()
        nodeManager.update(
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        #expect(paddle.position.x == 11.0)
    }

    @Test func movingToAFixedPointOverridesKeyMovement() {
        let paddle = PaddleSprite(position: paddlePosition, size: paddleSize)
        let nodeManager = makeManager(paddle)

        // keyboard movement
        nodeManager.startPaddleRight()
        nodeManager.update(
            deltaTime: 1.0,
            sceneSize: sceneSize
        )
        #expect(paddle.position.x == 11.0)

        // drag override
        nodeManager.beginPaddleKeyboardOverride(
            to: CGPoint(x: 3.0, y: 999),
            sceneSize: sceneSize
        )
        nodeManager.update(
            deltaTime: 1.0,
            sceneSize: sceneSize
        )
        #expect(paddle.position.x == 3.0)

        // resume keyboard
        nodeManager.endPaddleKeyboardOverride()
        nodeManager.update(
            deltaTime: 1.0,
            sceneSize: sceneSize
        )
        #expect(paddle.position.x == 4.0)
    }

    private func makeManager(_ paddle: PaddleSprite) -> DefaultNodeManager {
        DefaultNodeManager(
            ballLaunchController: BallLaunchController(),
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: PaddleBounceApplier(
                bounceSpeedPolicy: .neutral,
                bounceCalculator: BounceCalculator()
            ),
            brickLayoutFactory: FakeBrickLayoutFactory(),
            nodes: SceneNodes.createValid(
                paddle: paddle,
            ),
        )
    }

}
