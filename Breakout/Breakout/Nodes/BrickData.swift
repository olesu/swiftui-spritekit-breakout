import Foundation
import SpriteKit

struct BrickData {
    let id: String
    let position: Point
    let color: BrickColor
}

extension BrickData {
    var cgPosition: CGPoint {
        CGPoint(position)
    }
}
