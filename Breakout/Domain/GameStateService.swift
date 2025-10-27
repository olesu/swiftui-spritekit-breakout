import Foundation

protocol GameStateService {
    func transitionToPlaying()
    func getState() -> GameState
}

struct RealGameStateService: GameStateService {
    func transitionToPlaying() {
        print("Transition to playing")
    }

    func getState() -> GameState {
        .idle
    }
    
}
