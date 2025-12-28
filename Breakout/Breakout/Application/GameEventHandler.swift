import Foundation

final class GameEventHandler {
    private let gameEventSink: GameEventSink
    private let nodeManager: NodeManager
    private let soundProducer: SoundProducer

    init(gameEventSink: GameEventSink, nodeManager: NodeManager, soundProducer: SoundProducer) {
        self.gameEventSink = gameEventSink
        self.nodeManager = nodeManager
        self.soundProducer = soundProducer
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
        case .ballLost:
            soundProducer.play(.ballLost)
        }
    }
}
