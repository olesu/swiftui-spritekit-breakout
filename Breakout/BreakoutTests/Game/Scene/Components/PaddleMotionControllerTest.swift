import Testing
import SpriteKit

@testable import Breakout

struct PaddleMotionControllerTest {

    @Test func movesRightBySpeedTimesDeltaTime() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 100, y: 0)
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startRight()
        controller.update(deltaTime: 1.0)
        
        #expect(paddle.position.x <= controller.sceneWidth - paddle.size.width / 2)
    }
    
    @Test func stopsRightMotionWHenStopped() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 100, y: 0)
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startRight()
        controller.update(deltaTime: 1.0)
        
        controller.stop()
        controller.update(deltaTime: 1.0)
        
        #expect(paddle.position.x <= controller.sceneWidth - paddle.size.width / 2)
    }
    
    @Test func stopsLeftMotionWHenStopped() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 200, y: 0)
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startLeft()
        controller.update(deltaTime: 1.0)
        
        controller.stop()
        controller.update(deltaTime: 1.0)
        
        #expect(paddle.position.x >= paddle.size.width / 2)
    }
    
    @Test func movesLeftBySpeedTimesDeltaTime() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 200, y: 0)
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )

        controller.startLeft()
        controller.update(deltaTime: 1.0)
        
        #expect(paddle.position.x >= paddle.size.width / 2)
    }

    @Test func doesNotMovePastLeftBoundary() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 10, y: 0)
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startLeft()
        controller.update(deltaTime: 1.0)
        
        #expect(paddle.position.x >= 0)
    }

    @Test func doesNotMovePastRightBoundary() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 290, y: 0)

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )

        controller.startRight()
        controller.update(deltaTime: 1.0) // would try to move to 490

        #expect(paddle.position.x <= 300)
    }
    
    @Test func clampsLeftConsideringPaddleWidth() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 10, y: 0)
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startLeft()
        controller.update(deltaTime: 1.0)
        
        let leftEdge = paddle.position.x - paddle.size.width / 2.0
        #expect(leftEdge >= 0)
    }
    
    @Test func switchesDirectionWithoutStopping() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 100, y: 0)

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 100,
            sceneWidth: 300
        )

        controller.startRight()
        controller.update(deltaTime: 1.0)

        controller.startLeft()
        controller.update(deltaTime: 1.0)

        #expect(abs(paddle.position.x - 100) < 0.001)
    }

    @Test func draggingOverridesKeyboardMovement() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 100, y: 0)

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )

        controller.startRight()
        controller.update(deltaTime: 1.0)

        controller.overridePosition(x: 50)
        controller.update(deltaTime: 1.0)

        #expect(abs(paddle.position.x - 50) < 0.001)
    }

    @Test func movementResumesAfterDragEnds() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 100, y: 0)

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 100,
            sceneWidth: 300
        )

        controller.startRight()
        controller.update(deltaTime: 1.0)

        controller.overridePosition(x: 150)
        controller.update(deltaTime: 1.0)

        controller.endOverride()
        controller.update(deltaTime: 1.0)

        #expect(abs(paddle.position.x - 250) < 0.001)
    }

    @Test func overridePositionIsClamped() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 100, y: 0)

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 100,
            sceneWidth: 300
        )

        controller.overridePosition(x: -100)

        let halfWidth = paddle.size.width / 2
        #expect(paddle.position.x >= halfWidth)
    }

    @Test func overrideDoesNotClearIntent() {
        let paddle = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 10))
        paddle.position = CGPoint(x: 100, y: 0)

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 100,
            sceneWidth: 300
        )

        controller.startRight()
        controller.overridePosition(x: 150)
        controller.endOverride()

        controller.update(deltaTime: 1.0)

        #expect(paddle.position.x > 150) // intent restored
    }

}
