import Foundation
import Testing

@testable import Breakout

struct GameServiceTest {
    @Test func testStartGame_transitionsFromIdleToPlaying() {
        let service = BreakoutGameService()
        let state = GameState.initial

        let newState = service.startGame(state: state)

        #expect(newState.status == .playing)
    }

    @Test func testStartGame_whenAlreadyPlaying_returnsUnchangedState() {
        let service = BreakoutGameService()
        let state = GameState.initial.with(status: .playing)

        let newState = service.startGame(state: state)

        #expect(newState.status == .playing)
        #expect(newState == state)
    }

    @Test func testStartGame_whenGameWon_returnsUnchangedState() {
        let service = BreakoutGameService()
        let state = GameState.initial.with(status: .won)

        let newState = service.startGame(state: state)

        #expect(newState.status == .won)
        #expect(newState == state)
    }

    @Test func testStartGame_whenGameOver_returnsUnchangedState() {
        let service = BreakoutGameService()
        let state = GameState.initial.with(status: .gameOver)

        let newState = service.startGame(state: state)

        #expect(newState.status == .gameOver)
        #expect(newState == state)
    }
}
