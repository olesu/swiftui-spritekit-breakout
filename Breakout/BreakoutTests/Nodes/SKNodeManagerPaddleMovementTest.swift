import Foundation
import SpriteKit
import Testing

@testable import Breakout

struct SKNodeManagerPaddleMovementTest {

    @Test func controlsThePaddleByMovingLeft() {
        let s = Scenario()

        s.leftMotionFrame()
        s.stopMotionFrame()
        
        #expect(s.isPaddleAt(9.0) == true)
    }

    @Test func controlsThePaddleByMovingRight() {
        let s = Scenario()

        s.rightMotionFrame()
        s.stopMotionFrame()
        
        #expect(s.isPaddleAt(11.0) == true)
    }

    @Test func movingToAFixedPointOverridesKeyMovement() {
        let s = Scenario()

        s.rightMotionFrame()
        s.keyboardOverrideBeginFrame(x: 3.0)
        s.keyboardOverrideEndFrame()

        #expect(s.isPaddleAt(4.0) == true)
    }

}

private final class Scenario {
    private let sceneSize = Size(width: 100, height: 100)
    private let paddleMotionController = PaddleMotionController(speed: 1)
    private let ball = SKBallSprite(position: .zero)
    private let paddlePosition = Point(x: 10, y: 0)
    private let paddleSize = Size(width: 2, height: 20)
    private let paddle: PaddleSprite
    private let nodeManager: SKNodeManager

    init() {
        paddle = PaddleSprite(position: paddlePosition, size: paddleSize)
        nodeManager = SKNodeManager(
            ballLaunchController: BallLaunchController(),
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: PaddleBounceApplier(
                bounceSpeedPolicy: GameTuning.testNeutral.bounceSpeedPolicy,
                bounceCalculator: BounceCalculator()
            ),
            nodes: SceneNodes.createValid(
                paddle: paddle,
            ),
        )

    }
    
    func leftMotionFrame() {
        nodeManager.startPaddleLeft()
        doUpdate()
    }
    
    func rightMotionFrame() {
        nodeManager.startPaddleRight()
        doUpdate()
    }
    
    func stopMotionFrame() {
        nodeManager.stopPaddle()
        doUpdate()
    }
    
    func keyboardOverrideBeginFrame(x: Double) {
        nodeManager.beginPaddleKeyboardOverride(
            to: CGPoint(x: x, y: 999),
            sceneSize: CGSize(sceneSize)
        )
        doUpdate()
    }
    
    func keyboardOverrideEndFrame() {
        nodeManager.endPaddleKeyboardOverride()
        doUpdate()
    }
    
    private func doUpdate() {
        nodeManager.update(
            deltaTime: 1.0,
            sceneSize: sceneSize,
            visualGameState: .init(levelId: .only)
        )
    }
    
    func isPaddleAt(_ x: Double) -> Bool {
        abs(x - paddle.position.x) < 0.001
    }

}
