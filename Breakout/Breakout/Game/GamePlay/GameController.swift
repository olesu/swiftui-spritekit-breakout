import Foundation
import SpriteKit

final class GameController {
    private let paddleInputController: PaddleInputController
    private let game: RunningGame
    private let nodeManager: NodeManager
    
    weak var observer: GameSessionObserver?

    init(
        paddleInputController: PaddleInputController,
        game: RunningGame,
        nodeManager: NodeManager,
    ) {
        self.paddleInputController = paddleInputController
        self.game = game
        self.nodeManager = nodeManager
    }

    func step(deltaTime dt: TimeInterval, sceneSize: Size) {
        handleLevelTransitionIfNeeded()
        advanceWorld(deltaTime: dt, sceneSize: sceneSize, visualGameState: game.visualGameState)
        notifyObserver()
    }
    
    private func handleLevelTransitionIfNeeded() {
        if game.consumeLevelDidChange() {
            nodeManager.resetBricks()
        }
    }
    
    private func advanceWorld(deltaTime dt: TimeInterval, sceneSize: Size, visualGameState: VisualGameState) {
        if game.ballResetNeeded {
            performBallReset(sceneSize: sceneSize)
        } else {
            updateNodes(deltaTime: dt, sceneSize: sceneSize, visualGameState: visualGameState)
        }
    }
    
    private func performBallReset(sceneSize: Size) {
        game.announceBallResetInProgress()
        nodeManager.resetBall(sceneSize: sceneSize)
        game.acknowledgeBallReset()
    }
    
    private func updateNodes(deltaTime dt: TimeInterval, sceneSize: Size, visualGameState: VisualGameState) {
        nodeManager.update(
            deltaTime: dt,
            sceneSize: sceneSize,
            visualGameState: visualGameState,
        )
    }
    
    private func notifyObserver() {
        observer?.gameSessionDidUpdate()
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
        nodeManager.beginPaddleKeyboardOverride(to: point, sceneSize: sceneSize)
    }

    func endPaddleOverride() {
        nodeManager.endPaddleKeyboardOverride()
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
