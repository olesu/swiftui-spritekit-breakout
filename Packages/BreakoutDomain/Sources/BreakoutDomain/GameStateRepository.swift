import Foundation

public protocol GameStateRepository {
    func load() -> GameState
    func save(_ state: GameState)
}
