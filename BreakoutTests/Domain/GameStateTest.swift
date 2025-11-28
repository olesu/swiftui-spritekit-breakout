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

    @Test func testWithScore_updatesScore_keepsOtherFieldsUnchanged() {
        let state = GameState.initial
        let updated = state.with(score: 10)

        #expect(updated.score == 10)
        #expect(updated.lives == 3)
        #expect(updated.status == .idle)
        #expect(updated.bricks.isEmpty)
        #expect(updated.ballResetNeeded == false)
    }

    @Test func testWithLives_updatesLives_keepsOtherFieldsUnchanged() {
        let state = GameState.initial
        let updated = state.with(lives: 5)

        #expect(updated.score == 0)
        #expect(updated.lives == 5)
        #expect(updated.status == .idle)
        #expect(updated.bricks.isEmpty)
        #expect(updated.ballResetNeeded == false)
    }

    @Test func testWithStatus_updatesStatus_keepsOtherFieldsUnchanged() {
        let state = GameState.initial
        let updated = state.with(status: .playing)

        #expect(updated.score == 0)
        #expect(updated.lives == 3)
        #expect(updated.status == .playing)
        #expect(updated.bricks.isEmpty)
        #expect(updated.ballResetNeeded == false)
    }

    @Test func testWithBricks_updatesBricks_keepsOtherFieldsUnchanged() {
        let state = GameState.initial
        let brick = Brick(id: BrickId(of: "1"), color: .red)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let updated = state.with(bricks: bricks)

        #expect(updated.score == 0)
        #expect(updated.lives == 3)
        #expect(updated.status == .idle)
        #expect(updated.bricks.count == 1)
        #expect(updated.bricks[brick.id] == brick)
        #expect(updated.ballResetNeeded == false)
    }

    @Test func testWithBallResetNeeded_updatesBallResetFlag_keepsOtherFieldsUnchanged() {
        let state = GameState.initial
        let updated = state.with(ballResetNeeded: true)

        #expect(updated.score == 0)
        #expect(updated.lives == 3)
        #expect(updated.status == .idle)
        #expect(updated.bricks.isEmpty)
        #expect(updated.ballResetNeeded == true)
    }
}
