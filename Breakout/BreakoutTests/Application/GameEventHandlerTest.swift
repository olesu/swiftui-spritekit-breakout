import Testing

@testable import Breakout

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

    @Test func brickHitTriggersAnimation() {
        let sim = GameSimulation()

        sim.hitBrick(brickId: brick.id)

        #expect(sim.visualEffectsPlayed == [.brickHit])
    }

    @Test func ballLostPlaysSound() {
        let sim = GameSimulation()

        sim.loseBall()

        #expect(sim.soundsPlayed == [.ballLost])
    }

}

private final class GameSimulation {
    let gameEventSink: FakeGameEventSink
    let nodeManager: FakeNodeManager
    let soundEffectProducer: FakeSoundEffectProducer
    let visualEffectsProducer: FakeVisualEffectProducer

    let gameEventHandler: GameEventHandler

    init() {
        self.gameEventSink = FakeGameEventSink()
        self.nodeManager = FakeNodeManager()
        self.soundEffectProducer = FakeSoundEffectProducer()
        self.visualEffectsProducer = FakeVisualEffectProducer()

        self.gameEventHandler = GameEventHandler(
            gameEventSink: gameEventSink,
            nodeManager: nodeManager,
            soundEffectProducer: soundEffectProducer,
            visualEffectProducer: visualEffectsProducer,
        )
    }

    var receivedEvents: [GameEvent] {
        gameEventSink.receivedEvents
    }

    var removedBrickIds: [BrickId] {
        nodeManager.removedBrickIds
    }

    var soundsPlayed: [SoundEffect] {
        soundEffectProducer.soundEffectsPlayed
    }

    var visualEffectsPlayed: [VisualEffect] {
        visualEffectsProducer.visualEffectsPlayed
    }

    func hitBrick(brickId: BrickId) {
        gameEventHandler.handle(.brickHit(brickID: brickId))
        nodeManager.update(deltaTime: 1.0, sceneSize: .zero, visualGameState: .init(levelId: .only))
    }

    func loseBall() {
        gameEventHandler.handle(.ballLost)
    }

}
