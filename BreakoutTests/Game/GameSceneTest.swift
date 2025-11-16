import Testing
import SpriteKit
@testable import Breakout

@Suite("GameScene Tests")
struct GameSceneTest {

    @Test("Updates paddle position when moved")
    func updatesPaddlePositionWhenMoved() {
        let paddleNode = SKSpriteNode()
        let nodes: [NodeNames: SKNode] = [.paddle: paddleNode]

        let scene = GameScene(
            size: CGSize(width: 320, height: 480),
            brickArea: CGRect(x: 20, y: 330, width: 280, height: 120),
            nodes: nodes,
            onGameEvent: { _ in }
        )

        let testLocation = CGPoint(x: 100, y: 50)
        scene.movePaddle(to: testLocation)

        #expect(paddleNode.position.x == testLocation.x)
    }
}
