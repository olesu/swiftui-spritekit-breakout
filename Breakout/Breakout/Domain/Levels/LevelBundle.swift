import Foundation

struct LevelBundle {
    static let empty = LevelBundle(levels: [], bricks: [])

    let levels: [LevelId]
    let bricksById: [BrickId: Brick]

    init(levels: [LevelId], bricks: [Brick]) {
        self.levels = levels
        self.bricksById = Dictionary(
            uniqueKeysWithValues: bricks.map { ($0.id, $0) }
        )
    }
}
