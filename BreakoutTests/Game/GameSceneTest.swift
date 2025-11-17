import Testing
import SpriteKit
@testable import Breakout

@Suite("GameScene Tests")
struct GameSceneTest {

    @Test("Updates paddle position when moved") @MainActor
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

    @Test("Resets ball position and velocity") @MainActor
    func resetsBallPositionAndVelocity() {
        let ballNode = SKSpriteNode()
        ballNode.position = CGPoint(x: 250, y: 10)
        ballNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: 8))
        ballNode.physicsBody?.velocity = CGVector(dx: 100, dy: -50)

        let nodes: [NodeNames: SKNode] = [.ball: ballNode]

        let scene = GameScene(
            size: CGSize(width: 320, height: 480),
            brickArea: CGRect(x: 20, y: 330, width: 280, height: 120),
            nodes: nodes,
            onGameEvent: { _ in }
        )

        scene.resetBall()

        #expect(ballNode.position == CGPoint(x: 160, y: 50))
        #expect(ballNode.physicsBody?.velocity == CGVector(dx: 200, dy: 300))
    }
}
