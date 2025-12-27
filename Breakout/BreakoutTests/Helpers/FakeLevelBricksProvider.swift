import Foundation

@testable import Breakout

@MainActor
final class FakeLevelBricksProvider: LevelBricksProvider {
    static func providerForAllLevels(levels: [LevelId], bricks: [Brick]) -> FakeLevelBricksProvider {
        .init(
            bricksByLevel: Dictionary(
                uniqueKeysWithValues: levels.map { levelId in
                    (
                        levelId,
                        Dictionary(
                            uniqueKeysWithValues: bricks.map { ($0.id, $0) }
                        )
                    )
                }
            )
        )
    }
    let bricksByLevel: [LevelId: [BrickId: Brick]]

    init(bricksByLevel: [LevelId: [BrickId: Brick]]) {
        self.bricksByLevel = bricksByLevel
    }

    func bricks(for level: LevelId) -> [BrickId: Brick] {
        bricksByLevel[level] ?? [:]
    }
}
