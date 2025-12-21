import Foundation
import SpriteKit

final class GameController {
    private let paddleInputController: PaddleInputController
    private let gameSession: GameSession
    private let nodeManager: NodeManager

    init(
        paddleInputController: PaddleInputController,
        gameSession: GameSession,
        nodeManager: NodeManager,
    ) {
        self.paddleInputController = paddleInputController
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
        nodeManager.endPaddleOverride()
    }

    private func applyMovement() {
        switch paddleInputController.movement() {
        case .left:
            nodeManager.startPaddleLeft()
        case .right:
            nodeManager.startPaddleRight()
        case .none:
            nodeManager.stopPaddle()
        }
    }
}
