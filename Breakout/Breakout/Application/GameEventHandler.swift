import Foundation

final class GameEventHandler {
    private let gameEventSink: GameEventSink
    private let nodeManager: NodeManager

    init(gameEventSink: GameEventSink, nodeManager: NodeManager) {
        self.gameEventSink = gameEventSink
        self.nodeManager = nodeManager
    }

    func handle(_ event: GameEvent) {
        gameEventSink.handle(event)
        handlePresentation(for: event)
    }

    private func handlePresentation(for event: GameEvent) {
        switch event {
        case .brickHit(let brickId):
            nodeManager.enqueueRemoval(of: brickId)
        case .ballLost:
            break
        }
    }
}
