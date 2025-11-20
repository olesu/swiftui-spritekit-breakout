import Foundation

internal enum GameState {
    case idle
    case playing
    case won
    case gameOver
}

internal protocol GameStateService {
    func transitionToPlaying()
    func getState() -> GameState
}

internal struct RealGameStateService: GameStateService {
    private let adapter: GameStateAdapter

    internal init(adapter: GameStateAdapter) {
        self.adapter = adapter
    }

    internal func transitionToPlaying() {
        adapter.save(.playing)
    }

    internal func getState() -> GameState {
        adapter.read()
    }

}

internal protocol GameStateAdapter {
    func save(_ state: GameState)
    func read() -> GameState
}
