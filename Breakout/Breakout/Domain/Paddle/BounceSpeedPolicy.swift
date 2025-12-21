import Foundation

struct BounceSpeedPolicy {
    let multiplier: Double

    func apply(to velocity: Velocity) -> Velocity {
        Velocity(dx: velocity.dx * multiplier, dy: velocity.dy * multiplier)
    }
}

extension BounceSpeedPolicy {
    static let classic = BounceSpeedPolicy(multiplier: 1.03)
    static let neutral = BounceSpeedPolicy(multiplier: 1.0)
}
