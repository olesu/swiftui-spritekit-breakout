import Foundation
import SpriteKit

@testable import Breakout

final class FakeGameSceneBuilder: GameSceneBuilder {
    func makeScene() -> GameScene {
        let ballController = BallController()
        let paddleMotionController = PaddleMotionController(
            paddle: Paddle(x: 0, w: 0),
            speed: 0,
            sceneWidth: 0
        )
        let paddleInputController = PaddleInputController(motion: paddleMotionController)

        return GameScene(
            size: CGSize(width: 320, height: 480),
            collisionRouter: FakeCollisionRouter(),
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: DefaultNodeManager(brickLayoutFactory: FakeBrickLayoutFactory()),
            ballController: ballController,
            paddleInputController: paddleInputController
        )
    }

}
