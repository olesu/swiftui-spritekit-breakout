import Foundation
import SpriteKit

final class GameController {
    private let paddleInputController: PaddleInputController
    private let paddleMotionController: PaddleMotionController
    private let gameSession: GameSession
    private let nodeManager: NodeManager

    init(
        paddleInputController: PaddleInputController,
        paddleMotionController: PaddleMotionController,
        gameSession: GameSession,
        nodeManager: NodeManager,
    ) {
        self.paddleInputController = paddleInputController
        self.paddleMotionController = paddleMotionController
        self.gameSession = gameSession
        self.nodeManager = nodeManager
    }

    func step(deltaTime dt: TimeInterval, sceneSize: CGSize) {
        nodeManager.removeEnqueued()

        if gameSession.state.ballResetNeeded {
            gameSession.announceBallResetInProgress()
            nodeManager.clampBallToPaddle(sceneSize: sceneSize)
            gameSession.acknowledgeBallReset()
        } else {
            let newPaddle = paddleMotionController.update(
                paddle: Paddle(
                    x: nodeManager.paddle.position.x,
                    w: nodeManager.paddle.size.width
                ),
                deltaTime: dt,
                sceneSize: sceneSize
            )
            nodeManager.updatePaddleAndClampedBall(x: newPaddle.x)
        }
    }

    func pressLeft() {
        paddleInputController.pressLeft()
        applyMovement()
    }

    func releaseLeft() {
        paddleInputController.releaseLeft()
        applyMovement()
    }

    func pressRight() {
        paddleInputController.pressRight()
        applyMovement()
    }

    func releaseRight() {
        paddleInputController.releaseRight()
        applyMovement()
    }

    func movePaddle(to point: CGPoint, sceneSize: CGSize) {
        let newPaddle = paddleMotionController.overridePosition(
            paddle: Paddle(
                x: nodeManager.paddle.position.x,
                w: nodeManager.paddle.size.width
            ),
            x: point.x,
            sceneSize: sceneSize
        )
        nodeManager.paddle.position.x = CGFloat(newPaddle.x)
    }

    func endPaddleOverride() {
        paddleMotionController.endOverride()
    }

    private func applyMovement() {
        switch paddleInputController.movement() {
        case .left:
            paddleMotionController.startLeft()
        case .right:
            paddleMotionController.startRight()
        case .none:
            paddleMotionController.stop()
        }
    }
}
