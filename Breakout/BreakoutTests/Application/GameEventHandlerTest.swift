import Testing

@testable import Breakout

@MainActor
struct GameEventHandlerTest {
    let brick = Brick.createValid()

    @Test func brickHitTriggersNodeRemoval() {
        let sim = GameSimulation()

        sim.hitBrick(brickId: brick.id)

        #expect(sim.receivedEvents == [.brickHit(brickID: brick.id)])
        #expect(sim.removedBrickIds == [brick.id])
    }

    @Test func brickHitPlaysSound() {
        let sim = GameSimulation()

        sim.hitBrick(brickId: brick.id)

        #expect(sim.soundsPlayed == [.brickHit])
    }

    @Test func ballLostPlaysSound() {
        let sim = GameSimulation()

        sim.loseBall()

        #expect(sim.soundsPlayed == [.ballLost])
    }

}

@MainActor
private final class GameSimulation {
    let gameEventSink: FakeGameEventSink
    let nodeManager: FakeNodeManager
    let soundProducer: FakeSoundProducer

    let gameEventHandler: GameEventHandler

    init() {
        self.gameEventSink = FakeGameEventSink()
        self.nodeManager = FakeNodeManager()
        self.soundProducer = FakeSoundProducer()
        
        self.gameEventHandler = GameEventHandler(
            gameEventSink: gameEventSink,
            nodeManager: nodeManager,
            soundProducer: soundProducer,
        )
    }

    var receivedEvents: [GameEvent] {
        gameEventSink.receivedEvents
    }
    
    var removedBrickIds: [BrickId] {
        nodeManager.removedBrickIds
    }
    
    var soundsPlayed: [SoundEffect] {
        soundProducer.soundsPlayed
    }
    
    func hitBrick(brickId: BrickId) {
        gameEventHandler.handle(.brickHit(brickID: brickId))
        nodeManager.removeEnqueued()
    }
    
    func loseBall() {
        gameEventHandler.handle(.ballLost)
    }
    
}
