import Foundation

struct Ball: Equatable {
    let resetNeeded: Bool
    let resetInProgress: Bool

    static let initial = Ball(
        resetNeeded: false,
        resetInProgress: false,
    )

    func with(resetNeeded: Bool) -> Ball {
        .init(
            resetNeeded: resetNeeded,
            resetInProgress: resetInProgress,
        )
    }

    func with(resetInProgress: Bool) -> Ball {
        .init(
            resetNeeded: resetNeeded,
            resetInProgress: resetInProgress
        )
    }
}
