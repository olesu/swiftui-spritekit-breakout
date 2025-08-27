import Testing
import CoreGraphics
@testable import Breakout

struct PaddleTests {
    @Test func paddleHasExpectedInitialPositionAndSize() {
        let paddle = Paddle()
        #expect(paddle.position == CGPoint(x: 200, y: 50))
        #expect(paddle.size == CGSize(width: 80, height: 16))
    }

    @Test func paddleCanMoveHorizontally() {
        var paddle = Paddle()
        paddle.move(to: 120)
        #expect(paddle.position == CGPoint(x: 120, y: 50))
    }
}
