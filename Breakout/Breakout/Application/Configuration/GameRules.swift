import Foundation

struct GameRules {
    let tuning: GameTuning
    let startingLives: Int
    let maxLevels: Int
}

// MARK: Classic rules
extension GameRules {
    static let classic = GameRules(
        tuning: .classic,
        startingLives: 5,
        maxLevels: 2
    )
}
