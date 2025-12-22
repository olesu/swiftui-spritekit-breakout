import Foundation

struct BounceSpeedPolicy {
    let multiplier: Double

    func apply(to velocity: Velocity) -> Velocity {
        Velocity(dx: velocity.dx * multiplier, dy: velocity.dy * multiplier)
    }
}
