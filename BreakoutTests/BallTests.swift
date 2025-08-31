import Testing
import CoreGraphics

@testable import Breakout

struct BallTests {
    @Test func hasAPosition() async throws {
        #expect(Ball().position == CGPoint(x: 0, y: 0))
    }
}
