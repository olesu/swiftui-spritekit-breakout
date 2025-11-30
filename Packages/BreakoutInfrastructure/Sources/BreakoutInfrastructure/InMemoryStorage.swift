import Foundation
import BreakoutDomain

/// In-memory storage for game state.
@Observable public final class InMemoryStorage {
    public var status = GameStatus.idle
    public var didWinGame = false
    public var finalScore = 0
    
    public init() {}
}
