import Testing
import CoreGraphics

@testable import Breakout

struct BallTests {
    @Test func hasAPosition() async throws {
        #expect(Ball().position == CGPoint(x: 0, y: 0))
    }
    
    @Test func canMove() async throws {
        var ball = Ball(position: CGPoint(x: 1, y: 1))
        
        ball.move()
        
        #expect(ball.position == CGPoint(x: 2, y: 2))
    }
}
