import Foundation

final class GameEventHandler {
    private let gameEventSink: GameEventSink
    private let nodeManager: NodeManager
    private let soundEffectProducer: SoundEffectProducer
    private let visualEffectProducer: VisualEffectProducer

    init(
        gameEventSink: GameEventSink,
        nodeManager: NodeManager,
        soundEffectProducer: SoundEffectProducer,
        visualEffectProducer: VisualEffectProducer,
    ) {
        self.gameEventSink = gameEventSink
        self.nodeManager = nodeManager
        self.soundEffectProducer = soundEffectProducer
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
            soundEffectProducer.play(.brickHit)
            visualEffectProducer.play(.brickHit)
        case .ballLost:
            soundEffectProducer.play(.ballLost)
        }
    }
}
