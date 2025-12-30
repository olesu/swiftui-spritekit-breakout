import Foundation
import SpriteKit

struct BrickData {
    let id: String
    let position: Point
    let color: BrickColor

    init(id: String, position: Point, color: BrickColor) {
        self.id = id
        self.position = position
        self.color = color
    }
}

extension BrickData {
    var cgPosition: CGPoint {
        CGPoint(position)
    }
}
