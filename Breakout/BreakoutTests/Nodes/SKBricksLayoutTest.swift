import Testing
import SpriteKit

@testable import Breakout

struct SKBricksLayoutTest {

    @Test func acceptsCustomBrickLayout() throws {
        let bricks = [
            BrickData(id: "brick-001", position: Point(x: 10, y: 20), color: .red)
        ]

        let layout = SKBricksLayout(brickData: bricks)

        #expect(layout.brickData.count == 1)
        #expect(layout.brickData[0].position == Point(x: 10, y: 20))
        #expect(layout.brickData[0].color == .red)
    }

    @Test func brickDataAcceptsPredictableID() throws {
        let expectedId = "12345678-1234-1234-1234-123456789012"
        let brickData = BrickData(
            id: expectedId,
            position: Point(x: 5, y: 10),
            color: .green
        )

        #expect(brickData.id == expectedId)
        #expect(brickData.position == Point(x: 5, y: 10))
        #expect(brickData.color == .green)
    }

    @Test func layoutUsesBrickDataIDs() throws {
        let id1 = "11111111-1111-1111-1111-111111111111"
        let id2 = "22222222-2222-2222-2222-222222222222"

        let bricks = [
            BrickData(id: id1, position: Point(x: 0, y: 0), color: .red),
            BrickData(id: id2, position: Point(x: 0, y: 0), color: .green)
        ]

        let layout = SKBricksLayout(brickData: bricks)
        let addedBrickIds = layout.brickData.map { $0.id }

        #expect(addedBrickIds.count == 2)
        #expect(addedBrickIds[0] == id1)
        #expect(addedBrickIds[1] == id2)
    }

    @Test func brickSpriteUsesBrickDataPosition() {
        let data = BrickData(
            id: "brick-1",
            position: Point(x: 42, y: 1337),
            color: .red
        )

        let sprite = BrickSprite(brickData: data)

        #expect(sprite.node.position.x == 42)
        #expect(sprite.node.position.y == 1337)
    }

}
