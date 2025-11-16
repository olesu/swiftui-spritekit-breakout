import Testing
import SpriteKit
@testable import Breakout

@Suite("GameScene Tests")
struct GameSceneTest {

    @Test("Calls onPaddleMoved callback when paddle is moved")
    func callsOnPaddleMovedCallback() {
        var capturedLocation: CGPoint?

        let paddleNode = SKSpriteNode()
        let nodes: [NodeNames: SKNode] = [.paddle: paddleNode]

        let scene = GameScene(
            size: CGSize(width: 320, height: 480),
            brickArea: CGRect(x: 20, y: 330, width: 280, height: 120),
            nodes: nodes,
            onGameEvent: { _ in },
            onPaddleMoved: { location in
                capturedLocation = location
            }
        )

        let testLocation = CGPoint(x: 100, y: 50)
        scene.movePaddle(to: testLocation)

        #expect(capturedLocation == testLocation)
    }
}
