import Foundation

struct LoadBrickLayoutService {
    let adapter: BrickLayoutAdapter
    
    func load(named file: String) throws -> [BrickLayoutData] {
        let config = try adapter.load(fileName: file)
        return try BrickLayoutConfig.generateBricks(from: config)
    }
}
