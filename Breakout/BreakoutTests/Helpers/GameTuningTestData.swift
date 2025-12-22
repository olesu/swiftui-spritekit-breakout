import Foundation

@testable import Breakout

extension GameTuning {
    static let testNeutral: GameTuning = .init(
        paddleSpeed: 1.0,
        bounceSpeedPolicy: BounceSpeedPolicy(multiplier: 1.0),
    )
}
