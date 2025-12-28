import Testing

@testable import Breakout

@MainActor
struct GameEventHandlerTest {
    let brick = Brick.createValid()

    @Test func brickHitTriggersNodeRemoval() {
        let gameEventSink = FakeGameEventSink()
        let nodeManager = FakeNodeManager()
        let scenario = Scenario(
            gameEventSink: gameEventSink,
            nodeManager: nodeManager
        )

        scenario.simulateBrickHit(brickId: brick.id)

        #expect(gameEventSink.receivedEvents == [.brickHit(brickID: brick.id)])
        #expect(nodeManager.removedBrickIds == [brick.id])
    }

}

@MainActor
private final class Scenario {
    let handler: GameEventHandler
    let nodeManager: FakeNodeManager

    init(gameEventSink: GameEventSink, nodeManager: FakeNodeManager) {
        self.nodeManager = nodeManager
        self.handler = GameEventHandler(
            gameEventSink: gameEventSink,
            nodeManager: nodeManager
        )
    }

    func simulateBrickHit(brickId: BrickId) {
        handler.handle(.brickHit(brickID: brickId))
        nodeManager.removeEnqueued()
    }
}
