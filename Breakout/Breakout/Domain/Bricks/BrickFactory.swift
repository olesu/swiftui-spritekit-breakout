import Foundation

struct BrickFactory {
    static func makeBricks(from layout: [BrickLayoutData]) -> [Brick] {
        layout.map { item in
            Brick(
                id: BrickId(of: UUID().uuidString),
                color: item.color,
                position: Point(x: item.position.x, y: item.position.y)
            )
        }
    }
}
