import Foundation

@testable import Breakout

final class FakeGameEventSink: GameEventSink {
    var receivedEvents: [Breakout.GameEvent] = []
    
    func handle(_ event: Breakout.GameEvent) {
        receivedEvents.append(event)
    }
}
