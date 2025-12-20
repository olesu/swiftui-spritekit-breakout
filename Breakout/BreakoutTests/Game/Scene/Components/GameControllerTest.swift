import Foundation
import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct GameControllerTest {
    let sceneSize = CGSize(width: 100, height: 100)

    @Test func controlsThePaddleByMovingLeft() {
        let nodeManager = FakeNodeManager()
        let paddleMotionController = PaddleMotionController(speed: 1)
        let paddleInputController = PaddleInputController()

        let gameController = GameController(
            paddleInputController: paddleInputController,
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: nodeManager
        )

        gameController.pressLeft()
        gameController.tickInTest(sceneSize)
        gameController.releaseLeft()
        gameController.tickInTest(sceneSize)

        #expect(nodeManager.lastPaddleX == 9.0)
    }
    
    @Test func controlsThePaddleByMovingRight() {
        let nodeManager = FakeNodeManager()
        let paddleMotionController = PaddleMotionController(speed: 1)
        let paddleInputController = PaddleInputController()

        let gameController = GameController(
            paddleInputController: paddleInputController,
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: nodeManager
        )

        gameController.pressRight()
        gameController.tickInTest(sceneSize)
        gameController.releaseRight()
        gameController.tickInTest(sceneSize)

        #expect(nodeManager.lastPaddleX == 11.0)
    }

    @Test func movingToAFixedPointOverridesKeyMovement() {
        let nodeManager = FakeNodeManager()
        let paddleMotionController = PaddleMotionController(speed: 1)
        let paddleInputController = PaddleInputController()

        let gameController = GameController(
            paddleInputController: paddleInputController,
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: nodeManager
        )

        gameController.pressRight()
        gameController.tickInTest(sceneSize)
        #expect(nodeManager.lastPaddleX == 11.0)

        gameController.movePaddle(to: CGPoint(x: 3.0, y: 999), sceneSize: sceneSize)
        gameController.tickInTest(sceneSize)
        #expect(nodeManager.lastPaddleX == 3.0)

        gameController.endPaddleOverride()
        gameController.tickInTest(sceneSize)
        #expect(nodeManager.lastPaddleX == 4.0)
    }

}

extension GameController {
    fileprivate func tickInTest(_ sceneSize: CGSize) {
        self.step(deltaTime: 1.0, sceneSize: sceneSize)
    }
}

private final class FakeNodeManager: NodeManager {
    let paddle: SKSpriteNode
    let ball = SKSpriteNode()
    let bricks = SKNode()
    let topWall = SKSpriteNode()
    let leftWall = SKSpriteNode()
    let rightWall = SKSpriteNode()
    let gutter = SKSpriteNode()

    private(set) var lastPaddleX: CGFloat?

    init() {
        let paddle = SKSpriteNode()
        paddle.position.x = 10
        paddle.size.width = 2
        self.paddle = paddle
    }

    func enqueueRemoval(of brickId: BrickId) {}
    func removeEnqueued() {}
    func moveBall(to position: CGPoint) {}
    func clampBallToPaddle(sceneSize: CGSize) {}

    func updatePaddleAndClampedBall(x: CGFloat) {
        paddle.position.x = x
        lastPaddleX = x
    }
}
