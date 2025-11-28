import Foundation

internal protocol GameStateRepository {
    func load() -> GameState
    func save(_ state: GameState)
}
