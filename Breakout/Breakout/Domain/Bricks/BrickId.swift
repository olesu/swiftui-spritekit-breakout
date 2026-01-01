import Foundation

/// Unique identifier for a brick in the game.
nonisolated struct BrickId: Hashable {
    let value: String

    init(of value: String) {
        self.value = value
    }

}
