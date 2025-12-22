import Foundation

@testable import Breakout

final class FakeBrickService: BrickService {
    var loadedLayoutName = ""
    
    func load(layoutNamed file: String) throws -> [Breakout.Brick] {
        loadedLayoutName = file
        return []
    }
    
}
