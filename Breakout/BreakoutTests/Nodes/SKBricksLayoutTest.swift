import Testing
import AppKit

@testable import Breakout

struct ClassicBricksLayoutTest {

    @Test func acceptsCustomBrickLayout() throws {
        let bricks = [
            BrickSpec(data: BrickData(id: "brick-001", position: CGPoint(x: 10, y: 20), color: .red), color: .red)
        ]

        let layout = SKBricksLayout(brickSpecs: bricks)

        #expect(layout.brickSpecs.count == 1)
        #expect(layout.brickSpecs[0].data.position == CGPoint(x: 10, y: 20))
        #expect(layout.brickSpecs[0].data.color == .red)
        #expect(layout.brickSpecs[0].color == BrickColor.red)
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
            BrickSpec(data: BrickData(id: id1, position: CGPoint(x: 0, y: 0), color: .red), color: .red),
            BrickSpec(data: BrickData(id: id2, position: CGPoint(x: 0, y: 0), color: .green), color: .green)
        ]

        let layout = SKBricksLayout(brickSpecs: bricks)
        let addedBrickIds = layout.createdBricks.map { $0.id.value }

        #expect(addedBrickIds.count == 2)
        #expect(addedBrickIds[0] == id1)
        #expect(addedBrickIds[1] == id2)
    }
}
