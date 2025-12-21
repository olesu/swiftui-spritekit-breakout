import Foundation
import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct GameControllerTest {
    let sceneSize = CGSize(width: 100, height: 100)
    let paddleMotionController = PaddleMotionController(speed: 1)

    @Test func controlsThePaddleByMovingLeft() {
        let nodeManager = FakeNodeManager(
            paddleMotionController: paddleMotionController
        )
        let paddleInputController = PaddleInputController()

        let gameController = GameController(
            paddleInputController: paddleInputController,
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

        #expect(nodeManager.paddle.position.x == 9.0)
    }

    @Test func controlsThePaddleByMovingRight() {
        let nodeManager = FakeNodeManager(
            paddleMotionController: paddleMotionController
        )
        let paddleInputController = PaddleInputController()

        let gameController = GameController(
            paddleInputController: paddleInputController,
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

        #expect(nodeManager.paddle.position.x == 11.0)
    }

    @Test func movingToAFixedPointOverridesKeyMovement() {
        let nodeManager = FakeNodeManager(
            paddleMotionController: paddleMotionController
        )
        let paddleInputController = PaddleInputController()

        let gameController = GameController(
            paddleInputController: paddleInputController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: nodeManager
        )

        gameController.pressRight()
        gameController.tickInTest(sceneSize)
        #expect(nodeManager.paddle.position.x == 11.0)

        gameController.movePaddle(
            to: CGPoint(x: 3.0, y: 999),
            sceneSize: sceneSize
        )
        gameController.tickInTest(sceneSize)
        #expect(nodeManager.paddle.position.x == 3.0)

        gameController.endPaddleOverride()
        gameController.tickInTest(sceneSize)
        #expect(nodeManager.paddle.position.x == 4.0)
    }

}

extension GameController {
    fileprivate func tickInTest(_ sceneSize: CGSize) {
        self.step(deltaTime: 1.0, sceneSize: sceneSize)
    }
}

private final class FakeNodeManager: NodeManager {
    let paddleMotionController: PaddleMotionController

    init(paddleMotionController: PaddleMotionController) {
        self.paddleMotionController = paddleMotionController

        let paddle = SKSpriteNode()
        paddle.position = CGPoint(x: 10, y: 0)
        paddle.size = CGSize(width: 2, height: 10)
        self.paddle = paddle

    }

    let paddle: SKSpriteNode
    let ball = SKSpriteNode()
    let bricks = SKNode()
    let topWall = SKSpriteNode()
    let leftWall = SKSpriteNode()
    let rightWall = SKSpriteNode()
    let gutter = SKSpriteNode()

    func enqueueRemoval(of brickId: BrickId) {}
    func removeEnqueued() {}
    func moveBall(to position: CGPoint) {}
    func clampBallToPaddle(sceneSize: CGSize) {}

    func updatePaddleAndClampedBall(
        deltaTime dt: TimeInterval,
        sceneSize: CGSize
    ) {
        let newPaddle = paddleMotionController.update(
            paddle: Paddle(x: paddle.position.x, w: paddle.size.width),
            deltaTime: dt,
            sceneSize: sceneSize
        )
        paddle.position.x = CGFloat(newPaddle.x)
    }

    func movePaddle(to position: CGPoint, sceneSize: CGSize) {
        let newPaddle = paddleMotionController.overridePosition(
            paddle: Paddle(x: paddle.position.x, w: paddle.size.width),
            x: position.x,
            sceneSize: sceneSize
        )
        paddle.position.x = CGFloat(newPaddle.x)
    }
    
    func endPaddleOverride() {
        paddleMotionController.endOverride()
    }
    
    func startPaddleLeft() {
        paddleMotionController.startLeft()
    }
    
    func startPaddleRight() {
        paddleMotionController.startRight()
    }
    
    func stopPaddle() {
        paddleMotionController.stop()
    }
    

}
