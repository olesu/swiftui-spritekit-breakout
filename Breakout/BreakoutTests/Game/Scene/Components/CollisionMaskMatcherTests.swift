import Testing

@testable import Breakout

struct CollisionMaskMatcherTests {
    private let m = CollisionMaskMatcher()

    @Test func detectsBallBrick() {
        #expect(m.isBallBrick(m.ball | m.brick))
    }

    @Test func detectsBallGutter() {
        #expect(m.isBallGutter(m.ball | m.gutter))
    }

    @Test func detectsBallPaddle() {
        #expect(m.isBallPaddle(m.ball | m.paddle))
    }

}
