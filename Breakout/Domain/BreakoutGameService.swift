import Foundation

internal final class BreakoutGameService: GameService {
    
    internal func startGame(state: GameState) -> GameState {
        guard state.status == .idle else {
            return state
        }
        return state.with(status: .playing)
    }

    internal func processEvent(_ event: GameEvent, state: GameState) -> GameState {
        guard state.status == .playing else {
            return state
        }

        switch event {
        case .brickHit(let brickID):
            guard let brick = state.bricks[brickID] else {
                return state
            }

            var updatedBricks = state.bricks
            updatedBricks.removeValue(forKey: brickID)

            let newScore = state.score + brick.color.pointValue
            let newStatus = updatedBricks.isEmpty ? GameStatus.won : state.status

            return state
                .with(bricks: updatedBricks)
                .with(score: newScore)
                .with(status: newStatus)

        case .ballLost:
            let newLives = state.lives - 1
            let newStatus = newLives <= 0 ? GameStatus.gameOver : state.status
            let ballResetNeeded = newLives > 0

            return state
                .with(lives: newLives)
                .with(ballResetNeeded: ballResetNeeded)
                .with(status: newStatus)
        }
    }

    internal func acknowledgeBallReset(state: GameState) -> GameState {
        return state.with(ballResetNeeded: false)
    }
}
