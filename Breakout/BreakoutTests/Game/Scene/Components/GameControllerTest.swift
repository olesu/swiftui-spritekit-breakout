import Foundation
import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct GameControllerTest {
    let sceneSize = CGSize(width: 100, height: 100)

    @Test func controlsThePaddleByMovingLeft() {
        let paddleMotionController = PaddleMotionController.create()
        let paddleInputController = PaddleInputController()
        let gameController = GameController(
            paddleInputController: paddleInputController,
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: FakeNodeManager()
        )

        gameController.pressLeft()
        gameController.tickInTest(sceneSize)
        gameController.releaseLeft()
        gameController.tickInTest(sceneSize)

        #expect(paddleMotionController.paddle.x == 9.0)
    }

    @Test func controlsThePaddleByMovingRight() {
        let paddleMotionController = PaddleMotionController.create()
        let paddleInputController = PaddleInputController()
        let gameController = GameController(
            paddleInputController: paddleInputController,
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: FakeNodeManager()
        )
        gameController.pressRight()
        gameController.tickInTest(sceneSize)
        gameController.releaseRight()
        gameController.tickInTest(sceneSize)

        #expect(paddleMotionController.paddle.x == 11.0)
    }

    @Test func movingToAFixedPointOverridesKeyMovement() {
        let paddleMotionController = PaddleMotionController.create()
        let paddleInputController = PaddleInputController()
        let gameController = GameController(
            paddleInputController: paddleInputController,
            paddleMotionController: paddleMotionController,
            gameSession: GameSession(
                repository: InMemoryGameStateRepository(),
                reducer: GameReducer()
            ),
            nodeManager: FakeNodeManager()
        )

        gameController.pressRight()
        gameController.tickInTest(sceneSize)
        #expect(paddleMotionController.paddle.x == 11.0)
        gameController.movePaddle(to: CGPoint(x: 3.0, y: 999), sceneSize: sceneSize)
        gameController.tickInTest(sceneSize)
        #expect(paddleMotionController.paddle.x == 3.0)
        gameController.endPaddleOverride()
        gameController.tickInTest(sceneSize)
        #expect(paddleMotionController.paddle.x == 4.0)
    }

}

extension GameController {
    fileprivate func tickInTest(_ sceneSize: CGSize) {
        self.step(deltaTime: 1.0, sceneSize: sceneSize)
    }
}

extension PaddleMotionController {
    fileprivate static func create() -> PaddleMotionController {
        .init(
            paddle: Paddle(x: 10, w: 1),
            speed: 1
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
    
    func moveBall(to position: CGPoint) {

    }

    func clampBallToPaddle(sceneSize: CGSize) {
        
    }
    
    func updatePaddleAndClampedBall(x: CGFloat) {
        
    }
    
}
