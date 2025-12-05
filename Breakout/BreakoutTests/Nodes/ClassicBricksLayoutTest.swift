import Testing
import AppKit

@testable import Breakout

struct ClassicBricksLayoutTest {

    @Test func acceptsCustomBrickLayout() throws {
        let bricks = [
            (BrickData(id: UUID().uuidString, position: CGPoint(x: 10, y: 20), color: .red), BrickColor.red)
        ]

        let layout = ClassicBricksLayout(bricks: bricks, onBrickAdded: { _, _ in })

        #expect(layout.brickLayout.count == 1)
        #expect(layout.brickLayout[0].0.position == CGPoint(x: 10, y: 20))
        #expect(layout.brickLayout[0].0.color == .red)
        #expect(layout.brickLayout[0].1 == BrickColor.red)
    }

    @Test func brickDataAcceptsPredictableID() throws {
        let expectedId = "12345678-1234-1234-1234-123456789012"
        let brickData = BrickData(
            id: expectedId,
            position: CGPoint(x: 5, y: 10),
            color: .blue
        )

        #expect(brickData.id == expectedId)
        #expect(brickData.position == CGPoint(x: 5, y: 10))
        #expect(brickData.color == .blue)
    }

    @Test func layoutUsesBrickDataIDs() throws {
        let id1 = "11111111-1111-1111-1111-111111111111"
        let id2 = "22222222-2222-2222-2222-222222222222"

        let bricks = [
            (BrickData(id: id1, position: CGPoint(x: 10, y: 20), color: .red), BrickColor.red),
            (BrickData(id: id2, position: CGPoint(x: 30, y: 40), color: .green), BrickColor.green)
        ]

        var addedBrickIds: [String] = []
        let _ = ClassicBricksLayout(bricks: bricks, onBrickAdded: { idString, _ in
            addedBrickIds.append(idString)
        })

        #expect(addedBrickIds.count == 2)
        #expect(addedBrickIds[0] == id1)
        #expect(addedBrickIds[1] == id2)
    }
}
