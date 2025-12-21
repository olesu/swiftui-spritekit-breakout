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
            nodeManager.updatePaddleAndClampedBall(deltaTime: dt, sceneSize: sceneSize)
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
        nodeManager.movePaddle(to: point, sceneSize: sceneSize)
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
