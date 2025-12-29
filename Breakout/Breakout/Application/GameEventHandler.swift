import Foundation

final class GameEventHandler {
    private let gameEventSink: GameEventSink
    private let nodeManager: NodeManager
    private let soundProducer: SoundProducer
    private let visualEffectProducer: VisualEffectProducer

    init(
        gameEventSink: GameEventSink,
        nodeManager: NodeManager,
        soundProducer: SoundProducer,
        visualEffectProducer: VisualEffectProducer,
    ) {
        self.gameEventSink = gameEventSink
        self.nodeManager = nodeManager
        self.soundProducer = soundProducer
        self.visualEffectProducer = visualEffectProducer
    }

    func handle(_ event: GameEvent) {
        gameEventSink.handle(event)
        handlePresentation(for: event)
    }

    private func handlePresentation(for event: GameEvent) {
        switch event {
        case .brickHit(let brickId):
            nodeManager.enqueueRemoval(of: brickId)
            soundProducer.play(.brickHit)
            visualEffectProducer.play(.brickHit)
        case .ballLost:
            soundProducer.play(.ballLost)
        }
    }
}
