import Foundation
import BreakoutDomain

/// In-memory storage for game state.
@Observable public final class InMemoryStorage {
    public var status = GameStatus.idle
    public var gameResultDidWin = false
    public var gameResultScore = 0
    
    public init() {}
}
