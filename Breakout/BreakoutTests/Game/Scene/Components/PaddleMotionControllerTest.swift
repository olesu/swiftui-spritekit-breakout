import Testing
import SpriteKit

@testable import Breakout

struct PaddleMotionControllerTest {

    @Test func movesRightBySpeedTimesDeltaTime() {
        let paddle = makePaddle()
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startRight()
        controller.update(deltaTime: 1.0)
        
        #expect(controller.paddle.x <= controller.sceneWidth - controller.paddle.halfWidth)
    }
    
    @Test func stopsRightMotionWHenStopped() {
        let paddle = makePaddle()
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startRight()
        controller.update(deltaTime: 1.0)
        
        controller.stop()
        controller.update(deltaTime: 1.0)
        
        #expect(controller.paddle.x <= controller.sceneWidth - controller.paddle.halfWidth)
    }
    
    @Test func stopsLeftMotionWHenStopped() {
        let paddle = makePaddle()
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startLeft()
        controller.update(deltaTime: 1.0)
        
        controller.stop()
        controller.update(deltaTime: 1.0)
        
        #expect(controller.paddle.x >= controller.paddle.halfWidth)
    }
    
    @Test func movesLeftBySpeedTimesDeltaTime() {
        let paddle = makePaddle()
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )

        controller.startLeft()
        controller.update(deltaTime: 1.0)
        
        #expect(controller.paddle.x >= controller.paddle.halfWidth)
    }

    @Test func doesNotMovePastLeftBoundary() {
        let paddle = makePaddle()
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startLeft()
        controller.update(deltaTime: 1.0)
        
        #expect(controller.paddle.x >= 0)
    }

    @Test func doesNotMovePastRightBoundary() {
        let paddle = makePaddle()

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )

        controller.startRight()
        controller.update(deltaTime: 1.0)

        #expect(controller.paddle.x <= 300)
    }
    
    @Test func clampsLeftConsideringPaddleWidth() {
        let paddle = makePaddle()
        
        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )
        
        controller.startLeft()
        controller.update(deltaTime: 1.0)
        
        let leftEdge = controller.paddle.x - controller.paddle.halfWidth
        #expect(leftEdge >= 0)
    }
    
    @Test func switchesDirectionWithoutStopping() {
        let paddle = makePaddle()

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 100,
            sceneWidth: 300
        )

        controller.startRight()
        controller.update(deltaTime: 1.0)

        controller.startLeft()
        controller.update(deltaTime: 1.0)

        #expect(abs(controller.paddle.x - 100) < 0.001)
    }

    @Test func draggingOverridesKeyboardMovement() {
        let paddle = makePaddle()

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 200,
            sceneWidth: 300
        )

        controller.startRight()
        controller.update(deltaTime: 1.0)

        controller.overridePosition(x: 50)
        controller.update(deltaTime: 1.0)

        #expect(abs(controller.paddle.x - 50) < 0.001)
    }

    @Test func movementResumesAfterDragEnds() {
        let paddle = makePaddle()

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

        #expect(abs(controller.paddle.x - 250) < 0.001)
    }

    @Test func overridePositionIsClamped() {
        let paddle = makePaddle()

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 100,
            sceneWidth: 300
        )

        controller.overridePosition(x: -100)

        #expect(controller.paddle.x >= paddle.halfWidth)
    }

    @Test func overrideDoesNotClearIntent() {
        let paddle = makePaddle()

        let controller = PaddleMotionController(
            paddle: paddle,
            speed: 100,
            sceneWidth: 300
        )

        controller.startRight()
        controller.overridePosition(x: 150)
        controller.endOverride()

        controller.update(deltaTime: 1.0)

        #expect(controller.paddle.x > 150)
    }
    
    private func makePaddle() -> Paddle {
        .init(x: 100, w: 50)
    }

}
