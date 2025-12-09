import Foundation

final class BrickService {
    let adapter: BrickLayoutAdapter
    var cache: [String: [Brick]] = [:]

    init(adapter: BrickLayoutAdapter) {
        self.adapter = adapter
    }

    func load(named file: String) throws -> [Brick] {
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
