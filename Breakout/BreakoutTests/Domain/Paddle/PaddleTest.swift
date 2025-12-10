import Testing

@testable import Breakout

struct PaddleTest {

    @Test func shouldBePositionedAndSized() {
        let paddle = makePaddle(x: 10)
        
        #expect(paddle.x == 10)
        #expect(paddle.w == 100)
    }
    
    @Test func canMoveByAnAmount() {
        var paddle = makePaddle(x: 10)
        
        paddle = paddle.moveBy(amount: -5)
        
        #expect(paddle.x == 5)
    }
    
    @Test func canMoveToAbsolutePosition() {
        var paddle = makePaddle(x: 10)
        
        paddle = paddle.moveTo(20)
        
        #expect(paddle.x == 20)
    }
    
    private func makePaddle(x: Double) -> Paddle {
        .init(x: x, w: 100)
    }

}
