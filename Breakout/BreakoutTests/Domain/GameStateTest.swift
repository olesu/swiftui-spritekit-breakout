import Foundation
import Testing

@testable import Breakout

struct GameStateTest {
    private let startingLives = 5

    @Test func hasInitialDefaultValues() {
        let state = GameState.initial(startingLives: startingLives)

        #expect(state.score == 0)
        #expect(state.lives == startingLives)
        #expect(state.status == .idle)
        #expect(state.bricks.isEmpty)
        #expect(state.ballResetNeeded == false)
    }

    @Test func shouldUpdateScoreAndKeepOtherFieldsUnchanged() {
        let state = GameState.initial(startingLives: startingLives)
        let updated = state.with(score: 10)

        #expect(updated.score == 10)
        #expect(updated.lives == startingLives)
        #expect(updated.status == .idle)
        #expect(updated.bricks.isEmpty)
        #expect(updated.ballResetNeeded == false)
    }

    @Test func shouldUpdateLivesAndKeepOtherFieldsUnchanged() {
        let state = GameState.initial(startingLives: startingLives)
        let updated = state.with(lives: 5)

        #expect(updated.score == 0)
        #expect(updated.lives == 5)
        #expect(updated.status == .idle)
        #expect(updated.bricks.isEmpty)
        #expect(updated.ballResetNeeded == false)
    }

    @Test func shouldUpdateStatusAndKeepOtherFieldsUnchanged() {
        let state = GameState.initial(startingLives: startingLives)
        let updated = state.with(status: .playing)

        #expect(updated.score == 0)
        #expect(updated.lives == startingLives)
        #expect(updated.status == .playing)
        #expect(updated.bricks.isEmpty)
        #expect(updated.ballResetNeeded == false)
    }

    @Test func shouldUpdateBricksAndKeepOtherFieldsUnchanged() {
        let state = GameState.initial(startingLives: startingLives)
        let brick = Brick(id: BrickId(of: "1"), color: .red, position: .zero)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let updated = state.with(bricks: bricks)

        #expect(updated.score == 0)
        #expect(updated.lives == startingLives)
        #expect(updated.status == .idle)
        #expect(updated.bricks.count == 1)
        #expect(updated.bricks[brick.id] == brick)
        #expect(updated.ballResetNeeded == false)
    }

    @Test func shouldUpdateBallResetNeededAndKeepOtherFieldsUnchanged() {
        let state = GameState.initial(startingLives: startingLives)
        let updated = state.with(ballResetNeeded: true)

        #expect(updated.score == 0)
        #expect(updated.lives == startingLives)
        #expect(updated.status == .idle)
        #expect(updated.bricks.isEmpty)
        #expect(updated.ballResetNeeded == true)
    }
}
