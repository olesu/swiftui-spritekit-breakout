import Testing

@testable import Breakout

struct BallTest {

    @Test func shouldHaveInitialState() {
        let ball = Ball.initial

        #expect(ball.resetNeeded == false)
        #expect(ball.resetInProgress == false)
    }

    @Test func shouldUpdateBallResetNeeded() {
        let ball = Ball.initial

        let result = ball.with(resetNeeded: true)

        #expect(result.resetNeeded == true)
        #expect(result.resetInProgress == false)
    }

    @Test func shouldUpdateBallResetInProgress() {
        let ball = Ball.initial

        let result = ball.with(resetInProgress: true)

        #expect(result.resetNeeded == false)
        #expect(result.resetInProgress == true)
    }

}
