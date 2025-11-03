import Foundation

enum GameEvent: Equatable {
    case brickHit(brickID: UUID)
    case ballLost
}
