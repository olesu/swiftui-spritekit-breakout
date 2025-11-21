import Testing
import Foundation

@testable import Breakout

struct BrickLayoutConfigTest {

    @Test(arguments: [
        ("Red", BrickColor.red),
        ("Orange", BrickColor.orange),
        ("Yellow", BrickColor.yellow),
        ("Green", BrickColor.green)
    ])
    func mapsColorNameToBrickColor(colorName: String, expectedColor: BrickColor) throws {
        let brickType = BrickTypeConfig(id: 1, colorName: colorName, scoreValue: 1)

        #expect(try brickType.toBrickColor() == expectedColor)
    }

    @Test func throwsErrorForInvalidColorName() {
        let invalidType = BrickTypeConfig(id: 1, colorName: "InvalidColor", scoreValue: 1)

        #expect(throws: BrickTypeConfig.ColorError.self) {
            try invalidType.toBrickColor()
        }
    }

    @Test func generatesEmptyBricksArrayForEmptyLayout() throws {
        let config = BrickLayoutConfigMother.create(
            layout: [0, 0, 0, 0]
        )

        let bricks = try BrickLayoutConfig.generateBricks(from: config)

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

        let bricks = try BrickLayoutConfig.generateBricks(from: config)

        #expect(bricks.count == 1)
        #expect(bricks[0].position == CGPoint(x: 10, y: 100))
        #expect(bricks[0].color == BrickColor.red)
    }

    @Test func generatesMultipleBricksInRow() throws {
        let greenType = BrickTypeConfig(id: 1, colorName: "Green", scoreValue: 1)
        let config = BrickLayoutConfigMother.create(
            mapCols: 3,
            mapRows: 1,
            brickTypes: [greenType],
            layout: [1, 1, 1]
        )

        let bricks = try BrickLayoutConfig.generateBricks(from: config)

        #expect(bricks.count == 3)
        #expect(bricks[0].position == CGPoint(x: 11, y: 420))
        #expect(bricks[1].position == CGPoint(x: 34, y: 420))
        #expect(bricks[2].position == CGPoint(x: 57, y: 420))
    }

    @Test func generatesMultipleRows() throws {
        let yellowType = BrickTypeConfig(id: 1, colorName: "Yellow", scoreValue: 4)
        let config = BrickLayoutConfigMother.create(
            mapCols: 2,
            mapRows: 2,
            brickTypes: [yellowType],
            layout: [1, 1, 1, 1]
        )

        let bricks = try BrickLayoutConfig.generateBricks(from: config)

        #expect(bricks.count == 4)
        #expect(bricks[0].position == CGPoint(x: 11, y: 420))
        #expect(bricks[1].position == CGPoint(x: 34, y: 420))
        #expect(bricks[2].position == CGPoint(x: 11, y: 408))
        #expect(bricks[3].position == CGPoint(x: 34, y: 408))
    }
}
