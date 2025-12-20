import SpriteKit
import Testing

@testable import Breakout

struct DefaultNodeManagerTest {
    let ballLaunchController = BallLaunchController()

    @Test func removesBrickNodeById() {
        let brickId = BrickId(of: UUID().uuidString)
        let brick = BrickSprite(
            id: brickId.value,
            position: CGPoint(x: 100, y: 400),
            color: .red
        )

        let brickLayoutFactory = FakeBrickLayoutFactory()
        brickLayoutFactory.addToBrickLayout(brick)
        let manager = DefaultNodeManager(
            ballLaunchController: ballLaunchController,
            brickLayoutFactory: brickLayoutFactory
        )

        #expect(brick.parent != nil)

        manager.enqueueRemoval(of: brickId)
        manager.removeEnqueued()

        #expect(brick.parent == nil)
    }

    @Test func movesBall() {
        let manager = DefaultNodeManager(
            ballLaunchController: ballLaunchController,
            brickLayoutFactory: FakeBrickLayoutFactory()
        )

        manager.moveBall(to: CGPoint(x: 200, y: 500))

        #expect(manager.ball.position == CGPoint(x: 200, y: 500))
    }

}
