import Foundation

@testable import Breakout

class FakeGameStateService: GameStateService {
    var state: GameState

    init(initialState: GameState = .idle) {
        self.state = initialState
    }

    func transition(to newState: GameState) {
        state = newState
    }
}
