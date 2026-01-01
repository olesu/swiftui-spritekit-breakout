import Foundation

@testable import Breakout

final class FakeBrickLayoutAdapter: BrickLayoutAdapter {
    static let RedBrick = BrickTypeConfig(id: 1, colorName: "Red", scoreValue: 3)

    private var brickTypes: [BrickTypeConfig] = []
    private var brickLayout: [Int] = []

    func load(fileName: String) throws -> BrickLayoutConfig {
        BrickLayoutConfig.init(
            levelName: "a-level",
            mapCols: 1,
            mapRows: 1,
            startX: 0.0,
            startY: 0.0,
            brickWidth: 10.0,
            brickHeight: 10.0,
            spacing: 0.5,
            rowSpacing: 0.5,
            brickTypes: brickTypes,
            layout: brickLayout
        )
    }

    func setBrickTypes(_ brickTypes: [BrickTypeConfig]) {
        self.brickTypes = brickTypes
    }

    func setBrickLayout(_ brickLayout: [Int]) {
        self.brickLayout = brickLayout
    }

}
