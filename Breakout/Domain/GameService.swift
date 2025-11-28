import Foundation

internal protocol GameService {
    func startGame(state: GameState) -> GameState
    func processEvent(_ event: GameEvent, state: GameState) -> GameState
}
