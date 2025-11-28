import Foundation
import Testing

@testable import Breakout

struct GameStateTest {
    @Test func testInitialGameState_hasDefaultValues() {
        let state = GameState.initial

        #expect(state.score == 0)
        #expect(state.lives == 3)
        #expect(state.status == .idle)
        #expect(state.bricks.isEmpty)
        #expect(state.ballResetNeeded == false)
    }
}
