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
        manager.update(deltaTime: 1, sceneSize: .zero)

        #expect(brickLayoutFactory.hasParent(brickId) == false)
    }

    @Test func recordsLastBrickHitPositionWhenBrickRemovalIsQueued() {
        let brickId = BrickId.createValid()
        let brickLayoutFactory = makeBrickLayoutFactory(brickId)
        let manager = makeManager(brickLayoutFactory)

        manager.enqueueRemoval(of: brickId)

        #expect(
            manager.lastBrickHitPosition
                == brickLayoutFactory.position(of: brickId)
        )
    }

    @Test func movesBall() {
        let ball = SKBallSprite(position: .zero)
        let manager = makeManager(ball: ball)

        manager.moveBall(to: Point(x: 200, y: 500))

        #expect(abs(ball.position.x - 200) <= 0.001)
        #expect(abs(ball.position.y - 500) <= 0.001)
    }

    @Test func acceleratesBall() {
        let ball = SKBallSprite(position: .zero)
        let manager = makeManager(ball: ball)

        ball.setVelocity(.init(dx: 1.0, dy: 1.0))
        manager.ballHitPaddle()

        #expect(ball.velocity.dx - 1.03 < 0.001)
        #expect(ball.velocity.dy - 1.03 < 0.001)
    }

    private func makeBrickLayoutFactory(_ brickId: BrickId)
        -> FakeBrickLayoutFactory {
        let brick = BrickSprite(
            brickData: BrickData(
                id: brickId.value,
                position: Point(x: 100, y: 400),
                color: .red
            )
        )

        let brickLayoutFactory = FakeBrickLayoutFactory()
        brickLayoutFactory.addToContainer(brick)

        return brickLayoutFactory
    }

    private func makeManager(
        _ brickLayoutFactory: BrickLayoutFactory = FakeBrickLayoutFactory(),
        ball: SKBallSprite = .init(position: .zero)
    ) -> SKNodeManager {
        return SKNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: PaddleBounceApplier(
                bounceSpeedPolicy: GameTuning.testNeutral.bounceSpeedPolicy,
                bounceCalculator: BounceCalculator()
            ),
            nodes: SceneNodes.createValid(
                ball: ball,
                bricks: brickLayoutFactory.createNodes(),
            ),
        )
    }

}
