import Foundation

internal enum GameEvent: Equatable {
    case brickHit(brickID: UUID)
    case ballLost
}
