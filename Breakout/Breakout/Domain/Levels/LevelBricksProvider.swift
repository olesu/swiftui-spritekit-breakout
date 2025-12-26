import Foundation

protocol LevelBricksProvider {
    func bricks(for level: LevelId) -> [BrickId: Brick]
}
