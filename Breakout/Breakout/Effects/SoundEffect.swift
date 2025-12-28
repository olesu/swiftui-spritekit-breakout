import Foundation

enum SoundEffect: Equatable, CaseIterable {
    case brickHit
    case ballLost
}

extension SoundEffect {
    var fileName: String {
        switch self {
        case .brickHit:
            return "brick_hit.wav"
        case .ballLost:
            return "ball_lost.wav"
        }
    }
}
