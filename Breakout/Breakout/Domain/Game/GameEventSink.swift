import Foundation

protocol GameEventSink {
    func handle(_ event: GameEvent)
}
