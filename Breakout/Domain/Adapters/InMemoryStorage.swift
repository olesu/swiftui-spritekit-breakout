import Foundation

@Observable internal final class InMemoryStorage {
    internal var state = GameState.idle
}
