import Testing
import CoreGraphics

@testable import Breakout

struct PaddleTests {
    @Test func paddleHasExpectedInitialPositionAndSize() {
        let paddle = Paddle()
        #expect(paddle.position == CGPoint(x: 200, y: 50))
        #expect(paddle.size == CGSize(width: 80, height: 16))
    }
}
