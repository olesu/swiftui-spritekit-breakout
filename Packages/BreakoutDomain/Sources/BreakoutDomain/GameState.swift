import Foundation

public struct GameState: Equatable, Sendable {
    public let score: Int
    public let lives: Int
    public let status: GameStatus
    public let bricks: [BrickId: Brick]
    public let ballResetNeeded: Bool

    public static let initial = GameState(
        score: 0,
        lives: 3,
        status: .idle,
        bricks: [:],
        ballResetNeeded: false
    )

    public func with(score: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }

    public func with(lives: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }

    public func with(status: GameStatus) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }

    public func with(bricks: [BrickId: Brick]) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }

    public func with(ballResetNeeded: Bool) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ballResetNeeded: ballResetNeeded
        )
    }
}
