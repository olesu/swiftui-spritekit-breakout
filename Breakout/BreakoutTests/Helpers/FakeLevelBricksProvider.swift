import Foundation

@testable import Breakout

@MainActor
final class FakeLevelBricksProvider: LevelBricksProvider {
    let bricksByLevel: [LevelId: [BrickId: Brick]]
    
    init(bricksByLevel: [LevelId : [BrickId: Brick]]) {
        self.bricksByLevel = bricksByLevel
    }
    
    func bricks(for level: LevelId) -> [BrickId: Brick] {
        bricksByLevel[level]!
    }
}
