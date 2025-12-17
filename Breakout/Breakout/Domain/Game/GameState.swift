import Foundation

struct GameState: Equatable {
    let score: Int
    let lives: Int
    let status: GameStatus
    let bricks: [BrickId: Brick]
    let ballResetNeeded: Bool
    let ballResetInProgress: Bool

    static let initial = GameState(
        score: 0,
        lives: 3,
        status: .idle,
        bricks: [:],
        ballResetNeeded: false,
        ballResetInProgress: false
    )

    func with(score: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded,
            ballResetInProgress: ballResetInProgress
        )
    }

    func with(lives: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded,
            ballResetInProgress: ballResetInProgress
        )
    }

    func with(status: GameStatus) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded,
            ballResetInProgress: ballResetInProgress
        )
    }

    func with(bricks: [BrickId: Brick]) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded,
            ballResetInProgress: ballResetInProgress
        )
    }

    func with(ballResetNeeded: Bool) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded,
            ballResetInProgress: ballResetInProgress
        )
    }

    func with(ballResetInProgress: Bool) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded,
            ballResetInProgress: ballResetInProgress
        )
    }
}
