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
            return state
        }
    }
}
