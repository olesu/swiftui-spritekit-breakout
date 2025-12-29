import SpriteKit
import Testing

@testable import Breakout

struct SKNodeManagerTest {
    let ballLaunchController = BallLaunchController()
    let paddleMotionController = PaddleMotionController(speed: 450.0)
    let paddle = PaddleSprite(position: .zero, size: .zero)

    @Test func removesBrickNodeById() {
        let brickId = BrickId.createValid()
        let brickLayoutFactory = makeBrickLayoutFactory(brickId)
        let manager = makeManager(brickLayoutFactory)

        #expect(brickLayoutFactory.hasParent(brickId) == true)

        manager.enqueueRemoval(of: brickId)
        manager.removeEnqueued()

        #expect(brickLayoutFactory.hasParent(brickId) == false)
    }
    
    @Test func recordsLastBrickHitPositionWhenBrickRemovalIsQueued() {
        let brickId = BrickId.createValid()
        let brickLayoutFactory = makeBrickLayoutFactory(brickId)
        let manager = makeManager(brickLayoutFactory)

        manager.enqueueRemoval(of: brickId)
        
        #expect(manager.lastBrickHitPosition == brickLayoutFactory.position(of: brickId))
    }

    @Test func movesBall() {
        let ball = BallSprite(position: .zero)
        let manager = makeManager(ball: ball)

        manager.moveBall(to: CGPoint(x: 200, y: 500))

        #expect(abs(ball.position.x - 200) <= 0.001)
        #expect(abs(ball.position.y - 500) <= 0.001)
    }

    @Test func acceleratesBall() {
        let ball = BallSprite(position: .zero)
        let manager = makeManager(ball: ball)

        ball.physicsBody?.velocity = .init(dx: 1.0, dy: 1.0)
        manager.ballHitPaddle()

        guard let velocity = ball.physicsBody?.velocity else {
            #expect(Bool(false), "ball lacked velocity")
            return
        }

        #expect(velocity.dx - 1.03 < 0.001)
        #expect(velocity.dy - 1.03 < 0.001)
    }
    
    private func makeBrickLayoutFactory(_ brickId: BrickId) -> FakeBrickLayoutFactory {
        let brick = BrickSprite(
            id: brickId.value,
            position: CGPoint(x: 100, y: 400),
            color: .red
        )

        let brickLayoutFactory = FakeBrickLayoutFactory()
        brickLayoutFactory.addToBrickLayout(brick)
        
        return brickLayoutFactory
    }
    
    private func makeManager(
        _ brickLayoutFactory: BrickLayoutFactory = FakeBrickLayoutFactory(),
        ball: BallSprite = BallSprite(position: .zero)
    ) -> SKNodeManager {
        return SKNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: PaddleBounceApplier(
                bounceSpeedPolicy: GameTuning.testNeutral.bounceSpeedPolicy,
                bounceCalculator: BounceCalculator()
            ),
            brickLayoutFactory: brickLayoutFactory,
            nodes: SceneNodes.createValid(
                ball: ball,
                bricks: brickLayoutFactory.createNodes(),
            ),
        )
    }

}
