import Foundation
import SpriteKit

@testable import Breakout

final class FakeGameSceneBuilder: GameSceneBuilder {
    func makeScene(for session: GameSession) -> GameScene {
        // Ensure nodes contains a .brickLayout
        let nodes: [NodeNames: SKNode] = [
            .brickLayout: SKNode()
        ]

        return GameScene(
            size: CGSize(width: 320, height: 480),
            nodes: nodes,
            collisionRouter: FakeCollisionRouter(),
            paddleMotionController: PaddleMotionController(
                paddle: Paddle(x: 0, y: 0, w: 0, h: 0),
                speed: 0,
                sceneWidth: 0
            ),
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            )
        )
    }

}
