import Foundation

extension CGPoint {
    init(_ point: Point) {
        self.init(
            x: CGFloat(point.x),
            y: CGFloat(point.y)
        )
    }
}
