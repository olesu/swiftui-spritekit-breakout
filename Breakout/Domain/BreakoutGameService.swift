import Foundation

internal final class BreakoutGameService: GameService {
    internal func startGame(state: GameState) -> GameState {
        guard state.status == .idle else {
            return state
        }
        return state.with(status: .playing)
    }

    internal func processEvent(_ event: GameEvent, state: GameState) -> GameState {
        return state
    }
}
