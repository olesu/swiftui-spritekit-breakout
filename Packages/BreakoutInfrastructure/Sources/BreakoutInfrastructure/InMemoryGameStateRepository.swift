import Foundation
import BreakoutDomain

public final class InMemoryGameStateRepository: GameStateRepository {
    private var storedState: GameState = GameState.initial

    public init() {}

    public func load() -> GameState {
        return storedState
    }

    public func save(_ state: GameState) {
        storedState = state
    }
}
