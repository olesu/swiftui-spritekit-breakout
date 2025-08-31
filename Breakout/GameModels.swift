import Foundation
import CoreGraphics

struct Brick: Identifiable {
    let id: UUID
}

struct Paddle {
    var position: CGPoint
    var size: CGSize
    let minX: CGFloat
    let maxX: CGFloat

    init(
        position: CGPoint = CGPoint(x: 200, y: 50),
        size: CGSize = CGSize(width: 80, height: 16),
        minX: CGFloat = 0,
        maxX: CGFloat = 400
    ) {
        self.position = position
        self.size = size
        self.minX = minX
        self.maxX = maxX
    }

    mutating func move(to x: CGFloat) {
        let clampedX = min(max(x, minX), maxX)
        position = CGPoint(x: clampedX, y: position.y)
    }
}
