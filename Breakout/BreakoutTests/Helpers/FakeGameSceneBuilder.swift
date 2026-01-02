import Foundation
import SpriteKit

@testable import Breakout

final class FakeGameSceneBuilder: GameSceneBuilder {
    func makeScene() -> SKGameScene {
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
            reducer: GameReducer(),
            levelOrder: [],
            levelBricksProvider: DefaultLevelBricksProvider.empty,
            startingLives: 999
        )
        let nodes = SceneNodes.createValid()
        let nodeManager = SKNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: paddleBounceApplier,
            nodes: nodes
        )
        return SKGameScene(
            size: Size(width: 320, height: 480),
            nodes: nodes,
            ballLaunchController: ballLaunchController,
            contactHandler: SKGamePhysicsContactHandler(
                collisionRouter: collisionRouter,
                nodeManager: nodeManager,
                gameEventHandler: GameEventHandler(
                    gameEventSink: gameSession,
                    nodeManager: nodeManager,
                    soundEffectProducer: FakeSoundEffectProducer(),
                    visualEffectProducer: FakeVisualEffectProducer(),
                )
            ),
            gameController: GameController(
                paddleInputController: paddleInputController,
                game: gameSession,
                nodeManager: nodeManager,
            ),
        )
    }

}
