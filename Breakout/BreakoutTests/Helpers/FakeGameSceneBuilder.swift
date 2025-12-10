import Foundation
import SpriteKit

@testable import Breakout

final class FakeGameSceneBuilder: GameSceneBuilder {
    func makeScene() -> GameScene {
        // Ensure nodes contains a .brickLayout
        let nodes: [NodeNames: SKNode] = [
            .brickLayout: SKNode()
        ]
        
        let ballController = BallController()
        let paddleMotionController = PaddleMotionController(
            paddle: Paddle(x: 0, y: 0, w: 0, h: 0),
            speed: 0,
            sceneWidth: 0
        )
        let paddleInputController = PaddleInputController(motion: paddleMotionController)

        return GameScene(
            size: CGSize(width: 320, height: 480),
            nodes: nodes,
            collisionRouter: FakeCollisionRouter(),
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: BrickNodeManager(nodes: nodes),
            ballController: ballController,
            paddleInputController: paddleInputController
        )
    }

}
