import Foundation

/// Represents a single brick in the game.
nonisolated struct Brick: Equatable {
    let id: BrickId
    let color: BrickColor
    var value: Int {
        color.pointValue
    }

    init(id: BrickId, color: BrickColor = .green) {
        self.id = id
        self.color = color
    }
}
