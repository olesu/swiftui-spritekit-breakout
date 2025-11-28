import Foundation

@testable import Breakout

class FakeGameStatusAdapter: GameStatusAdapter {
    var currentStatus: GameStatus = .idle

    func save(_ state: GameStatus) {
        currentStatus = state
    }

    func read() -> GameStatus {
        currentStatus
    }
}
