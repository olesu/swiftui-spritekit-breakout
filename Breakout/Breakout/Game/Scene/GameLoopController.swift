import Foundation
import SpriteKit

final class GameLoopController {
    private let session: GameSession
    private let ballLaunch: BallLaunchController
    private let paddleMotion: PaddleMotionController
    private let nodes: NodeManager

    init(session: GameSession,
         ballLaunch: BallLaunchController,
         paddleMotion: PaddleMotionController,
         nodes: NodeManager) {
        self.session = session
        self.ballLaunch = ballLaunch
        self.paddleMotion = paddleMotion
        self.nodes = nodes
    }

    /// Advances the game loop by one step.
    /// - Parameters:
    ///   - dt: Delta time since the previous frame.
    ///   - sceneSize: The size of the scene, used to compute reset position.
    func step(deltaTime dt: TimeInterval, sceneSize: CGSize) {
        if session.state.ballResetNeeded {
            session.announceBallResetInProgress()
            ballLaunch.performReset(
                ball: nodes.ball,
                at: CGPoint(x: sceneSize.width / 2, y: 50)
            )
            session.acknowledgeBallReset()
        } else {
            paddleMotion.update(deltaTime: dt)
            nodes.paddle.position.x = CGFloat(paddleMotion.paddle.x)
            ballLaunch.update(ball: nodes.ball, paddle: nodes.paddle)
        }
    }
}
