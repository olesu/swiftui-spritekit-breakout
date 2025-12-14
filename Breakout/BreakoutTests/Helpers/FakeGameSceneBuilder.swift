import Foundation
import SpriteKit

@testable import Breakout

final class FakeGameSceneBuilder: GameSceneBuilder {
    func makeScene() -> GameScene {
        let ballLaunchController = BallLaunchController()
        let paddleMotionController = PaddleMotionController(
            paddle: Paddle(x: 0, w: 0),
            speed: 0,
            sceneWidth: 0
        )
        let paddleInputController = PaddleInputController(
            motion: paddleMotionController
        )
        let collisionRouter = FakeCollisionRouter()
        let gameSession = GameSession(
            repository: InMemoryGameStateRepository(),
            reducer: GameReducer()
            )
        let nodeManager = DefaultNodeManager(brickLayoutFactory: FakeBrickLayoutFactory())
        let ballMotionController = BallMotionController()
        let paddleBounceApplier = PaddleBounceApplier()
        let gameLoopController = GameLoopController(
            session: gameSession,
            ballLaunch: ballLaunchController,
            paddleMotion: paddleMotionController,
            nodes: nodeManager
        )

        return GameScene(
            size: CGSize(width: 320, height: 480),
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: DefaultNodeManager(
                brickLayoutFactory: FakeBrickLayoutFactory()
            ),
            ballLaunchController: ballLaunchController,
            ballMotionController: BallMotionController(),
            paddleInputController: paddleInputController,
            paddleBounceApplier: PaddleBounceApplier(),
            contactHandler: GamePhysicsContactHandler(
                collisionRouter: collisionRouter,
                gameSession: gameSession,
                nodeManager: nodeManager,
                ballMotionController: ballMotionController,
                paddleBounceApplier: paddleBounceApplier
            ),
            gameLoopController: gameLoopController
        )
    }

}
