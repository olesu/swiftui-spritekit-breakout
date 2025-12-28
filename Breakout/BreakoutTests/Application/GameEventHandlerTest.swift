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

    @Test func brickHitPlaysSound() {
        let gameEventSink = FakeGameEventSink()
        let nodeManager = FakeNodeManager()
        let soundProducer = FakeSoundProducer()

        let scenario = Scenario(
            gameEventSink: gameEventSink,
            nodeManager: nodeManager,
            soundProducer: soundProducer,
        )

        scenario.simulateBrickHit(brickId: brick.id)

        #expect(soundProducer.soundsPlayed == [.brickHit])
    }

}

@MainActor
private final class Scenario {
    let handler: GameEventHandler
    let nodeManager: FakeNodeManager
    let soundProducer: SoundProducer

    init(
        gameEventSink: GameEventSink,
        nodeManager: FakeNodeManager,
        soundProducer: SoundProducer = FakeSoundProducer(),
    ) {
        self.nodeManager = nodeManager
        self.handler = GameEventHandler(
            gameEventSink: gameEventSink,
            nodeManager: nodeManager,
            soundProducer: soundProducer,
        )
        self.soundProducer = soundProducer
    }

    func simulateBrickHit(brickId: BrickId) {
        handler.handle(.brickHit(brickID: brickId))
        nodeManager.removeEnqueued()
    }
}
