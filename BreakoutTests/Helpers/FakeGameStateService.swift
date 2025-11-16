import Foundation

@testable import Breakout

class FakeGameStateService: GameStateService {
    var currentState: GameState
    var stateTransitionedToPlaying: Bool = false

    init(initialState: GameState = .idle) {
        self.currentState = initialState
    }

    func transitionToPlaying() {
        stateTransitionedToPlaying = true
        currentState = .playing
    }

    func getState() -> GameState {
        currentState
    }
}
