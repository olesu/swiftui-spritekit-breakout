import Testing
import SpriteKit

@testable import Breakout

struct PaddleMotionControllerTest {
    private let sceneSize = CGSize(width: 300, height: 100)

    @Test func movesRightBySpeedTimesDeltaTime() {
        let paddle = makePaddle()
        
        let controller = PaddleMotionController(speed: 200)
        
        controller.startRight()
        let newPaddle = controller.update(paddle: paddle, deltaTime: 1.0, sceneSize: sceneSize)
        
        #expect(newPaddle.position.x <= sceneSize.width - newPaddle.halfWidth)
    }
    
    @Test func stopsRightMotionWHenStopped() {
        let paddle = makePaddle()
        
        let controller = PaddleMotionController(speed: 200)
        
        controller.startRight()
        let movingPaddle = controller.update(paddle: paddle, deltaTime: 1.0, sceneSize: sceneSize)
        
        controller.stop()
        let stoppedPaddle = controller.update(paddle: movingPaddle, deltaTime: 1.0, sceneSize: sceneSize)
        
        #expect(stoppedPaddle.position.x <= sceneSize.width - stoppedPaddle.halfWidth)
    }
    
    @Test func stopsLeftMotionWHenStopped() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 200)

        controller.startLeft()
        let movingPaddle = controller.update(
            paddle: paddle,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        controller.stop()
        let stoppedPaddle = controller.update(
            paddle: movingPaddle,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        #expect(stoppedPaddle.position.x >= stoppedPaddle.halfWidth)
    }

    @Test func movesLeftBySpeedTimesDeltaTime() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 200)

        controller.startLeft()
        let newPaddle = controller.update(
            paddle: paddle,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        #expect(newPaddle.position.x >= newPaddle.halfWidth)
    }

    @Test func doesNotMovePastLeftBoundary() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 200)

        controller.startLeft()
        let newPaddle = controller.update(
            paddle: paddle,
            deltaTime: 10.0,
            sceneSize: sceneSize
        )

        #expect(newPaddle.position.x >= newPaddle.halfWidth)
    }

    @Test func doesNotMovePastRightBoundary() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 200)

        controller.startRight()
        let newPaddle = controller.update(
            paddle: paddle,
            deltaTime: 10.0,
            sceneSize: sceneSize
        )

        #expect(newPaddle.position.x <= sceneSize.width - newPaddle.halfWidth)
    }

    @Test func clampsLeftConsideringPaddleWidth() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 200)

        controller.startLeft()
        let newPaddle = controller.update(
            paddle: paddle,
            deltaTime: 10.0,
            sceneSize: sceneSize
        )

        let leftEdge = newPaddle.position.x - newPaddle.halfWidth
        #expect(leftEdge >= 0)
    }

    @Test func switchesDirectionWithoutStopping() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 100)

        controller.startRight()
        let afterRight = controller.update(
            paddle: paddle,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        controller.startLeft()
        let afterLeft = controller.update(
            paddle: afterRight,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        #expect(abs(afterLeft.position.x - paddle.position.x) < 0.001)
    }

    @Test func draggingOverridesKeyboardMovement() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 200)

        controller.startRight()
        let movedPaddle = controller.update(
            paddle: paddle,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        let overridden = controller.overridePosition(
            paddle: movedPaddle,
            x: 50,
            sceneSize: sceneSize
        )

        let afterUpdate = controller.update(
            paddle: overridden,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        #expect(abs(afterUpdate.position.x - overridden.position.x) < 0.001)
    }

    @Test func movementResumesAfterDragEnds() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 100)

        controller.startRight()
        let moved = controller.update(
            paddle: paddle,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        let overridden = controller.overridePosition(
            paddle: moved,
            x: 150,
            sceneSize: sceneSize
        )

        controller.endOverride()
        let resumed = controller.update(
            paddle: overridden,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        #expect(abs(resumed.position.x - 250) < 0.001)
    }

    @Test func overridePositionIsClamped() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 100)

        let overridden = controller.overridePosition(
            paddle: paddle,
            x: -100,
            sceneSize: sceneSize
        )

        #expect(overridden.position.x >= overridden.halfWidth)
    }

    @Test func overrideDoesNotClearIntent() {
        let paddle = makePaddle()
        let controller = PaddleMotionController(speed: 100)

        controller.startRight()
        let overridden = controller.overridePosition(
            paddle: paddle,
            x: 150,
            sceneSize: sceneSize
        )

        controller.endOverride()
        let resumed = controller.update(
            paddle: overridden,
            deltaTime: 1.0,
            sceneSize: sceneSize
        )

        #expect(resumed.position.x > overridden.position.x)
    }

    private func makePaddle() -> Paddle {
        .init(position: Point(x: 100, y: 0), w: 50)
    }

}
