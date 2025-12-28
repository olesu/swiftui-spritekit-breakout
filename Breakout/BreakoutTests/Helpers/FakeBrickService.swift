import Foundation

@testable import Breakout

final class FakeBrickService: BrickService {
    var loadedLayoutName = ""
    
    func loadBundle(named file: String, levels: [Breakout.LevelId]) throws -> Breakout.LevelBundle {
        LevelBundle(levels: levels, bricks: try loadLayout(named: file))
    }
    
    private func loadLayout(named file: String) throws -> [Breakout.Brick] {
        loadedLayoutName = file
        return []
    }
    
}
