import Foundation

final class DefaultLevelBricksProvider: LevelBricksProvider {
    static let empty = DefaultLevelBricksProvider(.empty)

    private let bricksByLevel: [LevelId: [BrickId: Brick]]

    init(bricksByLevel: [LevelId: [BrickId: Brick]]) {
        self.bricksByLevel = bricksByLevel
    }

    init(_ bundle: LevelBundle) {
        bricksByLevel = Dictionary(
            uniqueKeysWithValues: bundle.levels.map { ($0, bundle.bricksById) }
        )
    }

    func bricks(for level: LevelId) -> [BrickId: Brick] {
        bricksByLevel[level] ?? [:]
    }

}
