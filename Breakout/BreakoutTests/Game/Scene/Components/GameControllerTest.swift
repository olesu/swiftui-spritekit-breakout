import Foundation
import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct GameControllerTest {

    @Test func controlsThePaddleByMovingLeft() {
        let paddleMotionController = PaddleMotionController.create()
        let paddleInputController = PaddleInputController()
        let gameController = GameController(
            ballLaunchController: BallLaunchController(),
            paddleInputController: paddleInputController,
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: FakeNodeManager()
        )

        gameController.pressLeft()
        gameController.tickInTest()
        gameController.releaseLeft()
        gameController.tickInTest()

        #expect(paddleMotionController.paddle.x == 9.0)
    }

    @Test func controlsThePaddleByMovingRight() {
        let paddleMotionController = PaddleMotionController.create()
        let paddleInputController = PaddleInputController()
        let gameController = GameController(
            ballLaunchController: BallLaunchController(),
            paddleInputController: paddleInputController,
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: FakeNodeManager()
        )

        gameController.pressRight()
        gameController.tickInTest()
        gameController.releaseRight()
        gameController.tickInTest()

        #expect(paddleMotionController.paddle.x == 11.0)
    }

    @Test func movingToAFixedPointOverridesKeyMovement() {
        let paddleMotionController = PaddleMotionController.create()
        let paddleInputController = PaddleInputController()
        let gameController = GameController(
            ballLaunchController: BallLaunchController(),
            paddleInputController: paddleInputController,
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: FakeNodeManager()
        )

        gameController.pressRight()
        gameController.tickInTest()
        #expect(paddleMotionController.paddle.x == 11.0)
        gameController.movePaddle(to: CGPoint(x: 3.0, y: 999))
        gameController.tickInTest()
        #expect(paddleMotionController.paddle.x == 3.0)
        gameController.endPaddleOverride()
        gameController.tickInTest()
        #expect(paddleMotionController.paddle.x == 4.0)
    }

}

extension GameController {
    fileprivate func tickInTest() {
        self.step(deltaTime: 1.0, sceneSize: .init(width: 100.0, height: 100.0))
    }
}

extension PaddleMotionController {
    fileprivate static func create() -> PaddleMotionController {
        .init(
            paddle: Paddle(x: 10, w: 1),
            speed: 1,
            sceneWidth: 20
        )
    }
}

private struct FakeNodeManager: NodeManager {
    var paddle: SKSpriteNode = SKSpriteNode()

    var ball: SKSpriteNode = SKSpriteNode()

    var bricks: SKNode = SKNode()

    var topWall: SKSpriteNode = SKSpriteNode()

    var leftWall: SKSpriteNode = SKSpriteNode()

    var rightWall: SKSpriteNode = SKSpriteNode()

    var gutter: SKSpriteNode = SKSpriteNode()

    func enqueueRemoval(of brickId: Breakout.BrickId) {
    }
   
    func removeEnqueued() {        
    }
    

}
