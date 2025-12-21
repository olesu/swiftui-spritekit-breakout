import Testing
import Foundation
@testable import Breakout

struct BounceCalculatorTest {

    @Test("Ball hits center of paddle - bounces mostly upward")
    func ballHitsCenterBouncesUpward() {
        let calculator = BounceCalculator()

        let ballX: CGFloat = 160
        let paddleX: CGFloat = 160
        let paddleWidth: CGFloat = 40
        let ballSpeed: CGFloat = 360

        let newVelocity = calculator.calculateBounce(
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
        let calculator = BounceCalculator()

        let ballX: CGFloat = 140  // Left edge
        let paddleX: CGFloat = 160  // Center
        let paddleWidth: CGFloat = 40
        let ballSpeed: CGFloat = 360

        let newVelocity = calculator.calculateBounce(
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

    @Test("Ball always bounces upward from paddle - even at extreme edge")
    func ballAlwaysBouncesUpward() {
        let calculator = BounceCalculator()

        let paddleX: CGFloat = 160
        let paddleWidth: CGFloat = 40
        let ballSpeed: CGFloat = 360

        // Test extreme left edge
        let leftEdgeVelocity = calculator.calculateBounce(
            ballX: 140,  // Far left
            paddleX: paddleX,
            paddleWidth: paddleWidth,
            ballSpeed: ballSpeed
        )

        // Test extreme right edge
        let rightEdgeVelocity = calculator.calculateBounce(
            ballX: 180,  // Far right
            paddleX: paddleX,
            paddleWidth: paddleWidth,
            ballSpeed: ballSpeed
        )

        // CRITICAL: Ball must ALWAYS bounce upward from paddle
        #expect(leftEdgeVelocity.dy > 0, "Left edge bounce must go upward")
        #expect(rightEdgeVelocity.dy > 0, "Right edge bounce must go upward")
    }

    @Test("Ball bounces upward even when hitting beyond paddle edge")
    func ballBouncesUpwardBeyondPaddleEdge() {
        let calculator = BounceCalculator()

        let paddleX: CGFloat = 160
        let paddleWidth: CGFloat = 40
        let ballSpeed: CGFloat = 360

        // Test WAY beyond left edge (outside paddle bounds)
        let farLeftVelocity = calculator.calculateBounce(
            ballX: 120,  // 40 units left of center (beyond paddle)
            paddleX: paddleX,
            paddleWidth: paddleWidth,
            ballSpeed: ballSpeed
        )

        // Test WAY beyond right edge (outside paddle bounds)
        let farRightVelocity = calculator.calculateBounce(
            ballX: 200,  // 40 units right of center (beyond paddle)
            paddleX: paddleX,
            paddleWidth: paddleWidth,
            ballSpeed: ballSpeed
        )

        // CRITICAL: Even beyond paddle, ball must bounce upward
        #expect(farLeftVelocity.dy > 0, "Far left bounce must go upward")
        #expect(farRightVelocity.dy > 0, "Far right bounce must go upward")
    }

    @Test("Maximum bounce angle is limited to 45 degrees")
    func maximumBounceAngleIsFortyFiveDegrees() {
        let calculator = BounceCalculator()

        let paddleX: CGFloat = 160
        let paddleWidth: CGFloat = 40
        let ballSpeed: CGFloat = 360

        // Hit at extreme right edge (should produce max angle)
        let edgeVelocity = calculator.calculateBounce(
            ballX: 180,  // Right edge
            paddleX: paddleX,
            paddleWidth: paddleWidth,
            ballSpeed: ballSpeed
        )

        // Calculate the actual angle from vertical
        let angleFromVertical = atan2(abs(edgeVelocity.dx), edgeVelocity.dy)
        let angleInDegrees = angleFromVertical * 180 / .pi

        // Should not exceed 45 degrees from vertical
        #expect(angleInDegrees <= 45.5, "Angle should be max 45°, got \(angleInDegrees)°")
    }
}
