import Foundation

final class LayoutLoadingBrickService: BrickService {
    let adapter: BrickLayoutAdapter
    var cache: [String: [Brick]] = [:]

    init(adapter: BrickLayoutAdapter) {
        self.adapter = adapter
    }

    func loadBundle(named file: String, levels: [LevelId]) throws -> LevelBundle {
        LevelBundle(levels: levels, bricks: try loadLayout(named: file))
    }
    
    private func loadLayout(named file: String) throws -> [Brick] {
        if let cached = cache[file] {
            return cached
        }

        let config = try adapter.load(fileName: file)
        let bricks: [Brick] = try BrickLayoutConfig.generateBricks(from: config)
            .map {
                layout in
                Brick.init(
                    id: BrickId(of: UUID().uuidString),
                    color: layout.color,
                    position: Point(x: layout.position.x, y: layout.position.y),
                )
            }

        cache[file] = bricks

        return bricks
    }
    
}
