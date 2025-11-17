import Foundation
import AppKit

@testable import Breakout

struct BrickLayoutConfigMother {
    private init() {}

    static func create(
        levelName: String = "Test Level",
        mapCols: Int = 14,
        mapRows: Int = 8,
        startX: CGFloat = 11,
        startY: CGFloat = 420,
        brickWidth: CGFloat = 20,
        brickHeight: CGFloat = 10,
        spacing: CGFloat = 3,
        rowSpacing: CGFloat = 12,
        brickTypes: [BrickTypeConfig] = [],
        layout: [Int] = []
    ) -> BrickLayoutConfig {
        BrickLayoutConfig(
            levelName: levelName,
            mapCols: mapCols,
            mapRows: mapRows,
            startX: startX,
            startY: startY,
            brickWidth: brickWidth,
            brickHeight: brickHeight,
            spacing: spacing,
            rowSpacing: rowSpacing,
            brickTypes: brickTypes,
            layout: layout
        )
    }
}
