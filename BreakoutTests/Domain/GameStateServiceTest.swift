import Testing

@testable import Breakout

struct GameStateServiceTest {

    @Test func canChangeTheGameState() async throws {
        let gameStateAdapter = FakeGameStateAdapter()
        let gameStateService = RealGameStateService(adapter: gameStateAdapter)
        
        gameStateService.transitionToPlaying()
        
        #expect(gameStateService.getState() == .playing)
    }

}

class FakeGameStateAdapter: GameStateAdapter {
    private var currentState: Breakout.GameState = .idle
    
    func save(_ state: Breakout.GameState) {
        currentState = state
    }
    
    func read() -> Breakout.GameState {
        currentState
    }
    
    
}
