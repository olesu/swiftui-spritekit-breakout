import Foundation

struct GameState: Equatable {
    let score: Int
    let lives: Int
    let status: GameStatus
    let bricks: [BrickId: Brick]
    let ball: Ball
    
    var ballResetNeeded: Bool {
        ball.resetNeeded
    }
    
    var ballResetInProgress: Bool {
        ball.resetInProgress
    }
    
    static let initial = GameState(
        score: 0,
        lives: 3,
        status: .idle,
        bricks: [:],
        ball: Ball.initial
    )

    func with(score: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball
        )
    }

    func with(lives: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball
        )
    }

    func with(status: GameStatus) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball
        )
    }

    func with(bricks: [BrickId: Brick]) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball
        )
    }

    func with(ballResetNeeded: Bool) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball.with(resetNeeded: ballResetNeeded),
        )
    }

    func with(ballResetInProgress: Bool) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball.with(resetInProgress: ballResetInProgress)
        )
    }
}
