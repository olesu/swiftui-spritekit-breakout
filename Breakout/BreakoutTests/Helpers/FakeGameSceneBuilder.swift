import Foundation
import SpriteKit

@testable import Breakout

final class FakeGameSceneBuilder: GameSceneBuilder {
    func makeScene() -> GameScene {
        let ballLaunchController = BallLaunchController()
        let paddleMotionController = PaddleMotionController(speed: 0)
        let paddleInputController = PaddleInputController()
        let paddleBounceApplier = PaddleBounceApplier(
            bounceSpeedPolicy: GameTuning.testNeutral.bounceSpeedPolicy,
            bounceCalculator: BounceCalculator()
        )

        let collisionRouter = FakeCollisionRouter()
        let gameSession = GameSession(
            repository: InMemoryGameStateRepository(),
            reducer: GameReducer()
        )
        let nodes = SceneNodes.createValid()
        let nodeManager = DefaultNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: paddleBounceApplier,
            brickLayoutFactory: FakeBrickLayoutFactory(),
            nodes: nodes
        )
        return GameScene(
            size: CGSize(width: 320, height: 480),
            nodes: nodes,
            ballLaunchController: ballLaunchController,
            contactHandler: GamePhysicsContactHandler(
                collisionRouter: collisionRouter,
                gameSession: gameSession,
                nodeManager: nodeManager
            ),
            gameController: GameController(
                paddleInputController: paddleInputController,
                gameSession: gameSession,
                nodeManager: nodeManager,
            ),
        )
    }

}
