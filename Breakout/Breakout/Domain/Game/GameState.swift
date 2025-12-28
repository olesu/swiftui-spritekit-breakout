import Foundation

struct GameState: Equatable {
    let score: Int
    let lives: Int
    let status: GameStatus
    let bricks: [BrickId: Brick]
    let ball: Ball
    let levelId: LevelId
    
    var ballResetNeeded: Bool {
        ball.resetNeeded
    }
    
    var ballResetInProgress: Bool {
        ball.resetInProgress
    }
    
    static func initial(startingLives: Int) -> GameState {
        .init(
            score: 0,
            lives: startingLives,
            status: .idle,
            bricks: [:],
            ball: Ball.initial,
            levelId: LevelId.level1
        )
    }

    func with(score: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball,
            levelId: levelId
        )
    }

    func with(lives: Int) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball,
            levelId: levelId
        )
    }

    func with(status: GameStatus) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball,
            levelId: levelId
        )
    }

    func with(bricks: [BrickId: Brick]) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball,
            levelId: levelId
        )
    }

    func with(ballResetNeeded: Bool) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball.with(resetNeeded: ballResetNeeded),
            levelId: levelId
        )
    }

    func with(ballResetInProgress: Bool) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball.with(resetInProgress: ballResetInProgress),
            levelId: levelId
        )
    }

    func with(levelId: LevelId) -> GameState {
        GameState(
            score: score,
            lives: lives,
            status: status,
            bricks: bricks,
            ball: ball,
            levelId: levelId
        )
    }
}
