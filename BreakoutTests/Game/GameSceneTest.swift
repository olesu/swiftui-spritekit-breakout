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
            nodes: nodes,
            onGameEvent: { _ in }
        )

        scene.resetBall()

        #expect(ballNode.position == CGPoint(x: 160, y: 50))
        #expect(ballNode.physicsBody?.velocity == CGVector(dx: 200, dy: 300))
    }

    @Test("Adjusts ball velocity when hitting paddle center") @MainActor
    func adjustsBallVelocityWhenHittingPaddleCenter() {
        let ballNode = SKSpriteNode()
        ballNode.position = CGPoint(x: 160, y: 50)
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        ballNode.physicsBody?.velocity = CGVector(dx: 200, dy: -300)

        let paddleNode = SKSpriteNode()
        paddleNode.position = CGPoint(x: 160, y: 40)
        let paddleSize = CGSize(width: 40, height: 8)
        paddleNode.physicsBody = SKPhysicsBody(rectangleOf: paddleSize)

        let nodes: [NodeNames: SKNode] = [.ball: ballNode, .paddle: paddleNode]

        let scene = GameScene(
            size: CGSize(width: 320, height: 480),
            nodes: nodes,
            onGameEvent: { _ in }
        )

        scene.adjustBallVelocityForPaddleHit()

        // Center hit should have minimal horizontal component
        #expect(abs(ballNode.physicsBody?.velocity.dx ?? 0) < 50)
        // Should bounce upward (positive dy)
        #expect((ballNode.physicsBody?.velocity.dy ?? 0) > 0)
    }
}
