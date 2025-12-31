import Foundation

struct BounceSpeedPolicy {
    let multiplier: Double

    func apply(to v: Vector) -> Vector {
        Vector(dx: v.dx * multiplier, dy: v.dy * multiplier)
    }
}
