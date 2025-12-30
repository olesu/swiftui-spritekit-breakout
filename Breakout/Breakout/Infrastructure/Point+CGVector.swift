import Foundation

extension CGVector {
    init(_ vector: Vector) {
        self.init(
            dx: CGFloat(vector.dx),
            dy: CGFloat(vector.dy)
        )
    }
}
