import Testing
import AppKit

@testable import Breakout

struct BrickLayoutConfigTest {

    @Test(arguments: [
        ("Red", NSColor.red),
        ("Orange", NSColor.orange),
        ("Yellow", NSColor.yellow),
        ("Green", NSColor.green)
    ])
    func mapsColorNameToNSColor(colorName: String, expectedColor: NSColor) throws {
        let brickType = BrickTypeConfig(id: 1, colorName: colorName, scoreValue: 1)

        #expect(try brickType.toNSColor() == expectedColor)
    }

    @Test func throwsErrorForInvalidColorName() {
        let invalidType = BrickTypeConfig(id: 1, colorName: "InvalidColor", scoreValue: 1)

        #expect(throws: BrickTypeConfig.ColorError.self) {
            try invalidType.toNSColor()
        }
    }

    @Test func generatesEmptyBricksArrayForEmptyLayout() throws {
        let config = BrickLayoutConfigMother.create(
            layout: [0, 0, 0, 0]
        )

        let bricks = try config.generateBricks()

        #expect(bricks.isEmpty)
    }

    @Test func generatesSingleBrickAtCorrectPosition() throws {
        let redType = BrickTypeConfig(id: 1, colorName: "Red", scoreValue: 7)
        let config = BrickLayoutConfigMother.create(
            mapCols: 1,
            mapRows: 1,
            startX: 10,
            startY: 100,
            brickTypes: [redType],
            layout: [1]
        )

        let bricks = try config.generateBricks()

        #expect(bricks.count == 1)
        #expect(bricks[0].position == CGPoint(x: 10, y: 100))
        #expect(bricks[0].color == .red)
    }

    @Test func generatesMultipleBricksInRow() throws {
        let greenType = BrickTypeConfig(id: 1, colorName: "Green", scoreValue: 1)
        let config = BrickLayoutConfigMother.create(
            mapCols: 3,
            mapRows: 1,
            brickTypes: [greenType],
            layout: [1, 1, 1]
        )

        let bricks = try config.generateBricks()

        #expect(bricks.count == 3)
        #expect(bricks[0].position == CGPoint(x: 11, y: 420))
        #expect(bricks[1].position == CGPoint(x: 34, y: 420))
        #expect(bricks[2].position == CGPoint(x: 57, y: 420))
    }
}
