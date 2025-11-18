import Testing
import Foundation
@testable import Breakout

@Suite("PaddleBounceCalculator Tests")
struct PaddleBounceCalculatorTest {

    @Test("Ball hits center of paddle - bounces mostly upward")
    func ballHitsCenterBouncesUpward() {
        let calculator = PaddleBounceCalculator()

        let ballX: CGFloat = 160
        let paddleX: CGFloat = 160
        let paddleWidth: CGFloat = 40
        let ballSpeed: CGFloat = 360

        let newVelocity = calculator.calculateBounceVelocity(
            ballX: ballX,
            paddleX: paddleX,
            paddleWidth: paddleWidth,
            ballSpeed: ballSpeed
        )

        // Center hit should have minimal horizontal component
        #expect(abs(newVelocity.dx) < 50)
        // Should bounce upward (positive dy)
        #expect(newVelocity.dy > 0)
    }

    @Test("Ball hits left edge of paddle - bounces left")
    func ballHitsLeftEdgeBouncesLeft() {
        let calculator = PaddleBounceCalculator()

        let ballX: CGFloat = 140  // Left edge
        let paddleX: CGFloat = 160  // Center
        let paddleWidth: CGFloat = 40
        let ballSpeed: CGFloat = 360

        let newVelocity = calculator.calculateBounceVelocity(
            ballX: ballX,
            paddleX: paddleX,
            paddleWidth: paddleWidth,
            ballSpeed: ballSpeed
        )

        // Left edge hit should have negative dx (bounce left)
        #expect(newVelocity.dx < 0)
        // Should bounce upward (positive dy)
        #expect(newVelocity.dy > 0)
    }
}
