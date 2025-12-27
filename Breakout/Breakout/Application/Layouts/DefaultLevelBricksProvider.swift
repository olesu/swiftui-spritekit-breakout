import Foundation

final class DefaultLevelBricksProvider: LevelBricksProvider {
    static func providerForAllLevels(levels: [LevelId], bricks: [Brick]) -> DefaultLevelBricksProvider {
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
    
    static let empty = providerForAllLevels(levels: [], bricks: [])
    
    private let bricksByLevel: [LevelId: [BrickId: Brick]]
    
    init(bricksByLevel: [LevelId : [BrickId : Brick]]) {
        self.bricksByLevel = bricksByLevel
    }
    
    func bricks(for level: LevelId) -> [BrickId: Brick] {
        bricksByLevel[level] ?? [:]
    }
    
}
