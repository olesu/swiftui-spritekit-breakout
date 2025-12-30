import Testing

@testable import Breakout

struct PaddleTest {

    @Test func shouldBePositionedAndSized() {
        let paddle = makePaddle(x: 10)
        
        #expect(paddle.position.x == 10)
        #expect(paddle.w == 100)
    }
    
    @Test func canMoveByAnAmount() {
        var paddle = makePaddle(x: 10)
        
        paddle = paddle.moveBy(amount: -5)
        
        #expect(paddle.position.x == 5)
    }
    
    @Test func canMoveToAbsolutePosition() {
        var paddle = makePaddle(x: 10)
        
        paddle = paddle.moveTo(Point(x: 20, y: 0))
        
        #expect(paddle.position.x == 20)
    }
    
    private func makePaddle(x: Double) -> Paddle {
        .init(position: Point(x: x, y: 0), w: 100)
    }

}
