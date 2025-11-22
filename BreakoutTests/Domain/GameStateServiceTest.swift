import Testing

@testable import Breakout

struct GameStateServiceTest {

    @Test(arguments: [GameState.idle, GameState.playing, GameState.won, GameState.gameOver])
    func canTransitionToState(state: GameState) async throws {
        let gameStateAdapter = FakeGameStateAdapter()
        let gameStateService = RealGameStateService(adapter: gameStateAdapter)

        gameStateService.transition(to: state)

        #expect(gameStateService.state == state)
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
