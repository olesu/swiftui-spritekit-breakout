import Foundation

struct GameReducer {

    func start(_ state: GameState) -> GameState {
        guard state.status == .idle else {
            return state
        }
        return state.with(status: .playing)
    }

    func reduce(_ state: GameState, event: GameEvent) -> GameState {
        guard state.status == .playing else {
            return state
        }
        switch event {
        case .brickHit(let id):
            return reduceBrickHit(id: id, state: state)
        case .ballLost:
            return reduceBallLost(state)
        }
    }
    
    func announcedBallResetInProgress(_ state: GameState) -> GameState {
        guard state.ballResetNeeded else {
            return state
        }
        return state
            .with(ballResetNeeded: false)
            .with(ballResetInProgress: true)
    }

    func acknowledgeBallReset(_ state: GameState) -> GameState {
        return state.with(ballResetInProgress: false)
    }

    private func reduceBrickHit(id: BrickId, state: GameState) -> GameState {
        guard let brick = state.bricks[id] else {
            return state
        }

        var updatedBricks = state.bricks
        updatedBricks.removeValue(forKey: id)

        let newScore = state.score + brick.color.pointValue
        let newStatus = updatedBricks.isEmpty ? GameStatus.won : state.status

        return
            state
            .with(bricks: updatedBricks)
            .with(score: newScore)
            .with(status: newStatus)
    }

    private func reduceBallLost(_ state: GameState) -> GameState {
        let newLives = state.lives - 1
        let newStatus = newLives <= 0 ? GameStatus.gameOver : state.status
        let ballResetNeeded = newLives > 0

        return
            state
            .with(lives: newLives)
            .with(ballResetNeeded: ballResetNeeded)
            .with(status: newStatus)
    }

}
