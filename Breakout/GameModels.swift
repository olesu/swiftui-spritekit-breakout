import Foundation
import CoreGraphics

struct Brick: Identifiable {
    let id: UUID
}

struct Paddle {
    var position: CGPoint = CGPoint(x: 200, y: 50)
    var size: CGSize = CGSize(width: 80, height: 16)

    mutating func move(to x: CGFloat) {
        position = CGPoint(x: x, y: position.y)
    }
}
