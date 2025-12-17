import SpriteKit
import Foundation

final class GameController {
    private let ballLaunchController: BallLaunchController
    private let paddleInputController: PaddleInputController
    private let paddleMotionController: PaddleMotionController
    private let gameSession: GameSession
    private let nodeManager: NodeManager

    init(
        ballLaunchController: BallLaunchController,
        paddleInputController: PaddleInputController,
        paddleMotionController: PaddleMotionController,
        gameSession: GameSession,
        nodeManager: NodeManager,
    ) {
        self.ballLaunchController = ballLaunchController
        self.paddleInputController = paddleInputController
        self.paddleMotionController = paddleMotionController
        self.gameSession = gameSession
        self.nodeManager = nodeManager
    }

    func step(deltaTime dt: TimeInterval, sceneSize: CGSize) {
        if gameSession.state.ballResetNeeded {
            gameSession.announceBallResetInProgress()
            ballLaunchController.performReset(
                ball: nodeManager.ball,
                at: CGPoint(x: sceneSize.width / 2, y: 50)
            )
            gameSession.acknowledgeBallReset()
        } else {
            paddleMotionController.update(deltaTime: dt)
            nodeManager.paddle.position.x = CGFloat(paddleMotionController.paddle.x)
            ballLaunchController.update(ball: nodeManager.ball, paddle: nodeManager.paddle)
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

    func movePaddle(to point: CGPoint) {
        paddleMotionController.overridePosition(x: point.x)
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
