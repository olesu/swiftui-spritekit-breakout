import Foundation

nonisolated struct GameState: Equatable {
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

    func with(score: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }

    func with(lives: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }

    func with(status: GameStatus) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }

    func with(bricks: [BrickId: Brick]) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }

    func with(ballResetNeeded: Bool) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }
}
