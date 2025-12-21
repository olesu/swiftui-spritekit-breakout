import SpriteKit
import Testing

@testable import Breakout

struct DefaultNodeManagerTest {
    let ballLaunchController = BallLaunchController()
    let paddleMotionController = PaddleMotionController(speed: 450.0)
    let paddle = PaddleSprite(position: .zero, size: .zero)

    @Test func removesBrickNodeById() {
        let brickId = BrickId(of: UUID().uuidString)
        let brick = BrickSprite(
            id: brickId.value,
            position: CGPoint(x: 100, y: 400),
            color: .red
        )

        let brickLayoutFactory = FakeBrickLayoutFactory()
        brickLayoutFactory.addToBrickLayout(brick)
        let manager = makeManager(brickLayoutFactory)

        #expect(brick.parent != nil)

        manager.enqueueRemoval(of: brickId)
        manager.removeEnqueued()

        #expect(brick.parent == nil)
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

    private func makeManager(
        _ brickLayoutFactory: BrickLayoutFactory = FakeBrickLayoutFactory(),
        ball: BallSprite = BallSprite(position: .zero)
    ) -> DefaultNodeManager {
        return DefaultNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: PaddleBounceApplier(
                bounceSpeedPolicy: .neutral,
                bounceCalculator: BounceCalculator()
            ),
            brickLayoutFactory: brickLayoutFactory,
            nodes: SceneNodes.createValid(
                ball: ball,
                bricks: brickLayoutFactory.createBrickLayout(),
            ),
        )
    }

}
