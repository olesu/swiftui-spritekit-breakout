import Foundation

enum GameState {
    case idle
    case playing
}

protocol GameStateService {
    func transitionToPlaying()
    func getState() -> GameState
}

struct RealGameStateService: GameStateService {
    let adapter: GameStateAdapter
    
    init(adapter: GameStateAdapter) {
        self.adapter = adapter
    }
    
    func transitionToPlaying() {
        adapter.save(.playing)
    }

    func getState() -> GameState {
        adapter.read()
    }
    
}

protocol GameStateAdapter {
    func save(_ state: GameState)
    func read() -> GameState
}
