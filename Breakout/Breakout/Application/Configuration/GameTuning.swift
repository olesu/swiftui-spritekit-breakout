import Foundation

struct GameTuning {
    let paddleSpeed: CGFloat
    let bounceSpeedPolicy: BounceSpeedPolicy
}

// MARK: Classic
extension GameTuning {
    static let classic = GameTuning(
        paddleSpeed: 450.0,
        bounceSpeedPolicy: BounceSpeedPolicy(multiplier: 1.03)
    )
}
