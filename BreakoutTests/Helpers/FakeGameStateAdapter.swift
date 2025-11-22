import Foundation

@testable import Breakout

class FakeGameStateAdapter: GameStateAdapter {
    var currentState: GameState = .idle

    func save(_ state: GameState) {
        currentState = state
    }

    func read() -> GameState {
        currentState
    }
}
