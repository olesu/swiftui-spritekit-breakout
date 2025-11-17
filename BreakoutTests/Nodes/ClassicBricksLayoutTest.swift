import Testing
import AppKit

@testable import Breakout

struct ClassicBricksLayoutTest {

    @Test @MainActor func acceptsCustomBrickLayout() throws {
        let bricks = [
            BrickData(position: CGPoint(x: 10, y: 20), color: .red)
        ]

        let layout = ClassicBricksLayout(bricks: bricks, onBrickAdded: { _, _ in })

        #expect(layout.brickLayout.count == 1)
        #expect(layout.brickLayout[0].position == CGPoint(x: 10, y: 20))
        #expect(layout.brickLayout[0].color == .red)
    }
}
