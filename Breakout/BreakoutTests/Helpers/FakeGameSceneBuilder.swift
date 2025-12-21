import Foundation
import SpriteKit

@testable import Breakout

final class FakeGameSceneBuilder: GameSceneBuilder {
    func makeScene() -> GameScene {
        let ballLaunchController = BallLaunchController()
        let paddleMotionController = PaddleMotionController(speed: 0)
        let paddleInputController = PaddleInputController()
        let collisionRouter = FakeCollisionRouter()
        let gameSession = GameSession(
            repository: InMemoryGameStateRepository(),
            reducer: GameReducer()
        )
        let nodeManager = DefaultNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            brickLayoutFactory: FakeBrickLayoutFactory(),
            paddle: PaddleSprite(position: .zero, size: .zero),
            ball: BallSprite(position: .zero)
        )
        let paddleBounceApplier = PaddleBounceApplier()

        return GameScene(
            size: CGSize(width: 320, height: 480),
            nodeManager: nodeManager,
            ballLaunchController: ballLaunchController,
            contactHandler: GamePhysicsContactHandler(
                collisionRouter: collisionRouter,
                gameSession: gameSession,
                nodeManager: nodeManager,
                paddleBounceApplier: paddleBounceApplier
            ),
            gameController: GameController(
                paddleInputController: paddleInputController,
                gameSession: gameSession,
                nodeManager: nodeManager,
            ),
        )
    }

}
