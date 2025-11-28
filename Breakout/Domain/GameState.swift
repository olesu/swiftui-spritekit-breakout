import Foundation

internal struct GameState: Equatable {
    let score: Int
    let lives: Int
    let status: GameStatus
    let bricks: [BrickId: Brick]
    let ballResetNeeded: Bool

    static let initial = GameState(
        score: 0,
        lives: 3,
        status: .idle,
        bricks: [:],
        ballResetNeeded: false
    )
}
