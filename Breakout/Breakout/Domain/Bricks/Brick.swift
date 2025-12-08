import Foundation

/// Represents a single brick in the game.
struct Brick: Equatable {
    let id: BrickId
    let color: BrickColor
    let position: Point
    var value: Int {
        color.pointValue
    }

    init(id: BrickId, color: BrickColor, position: Point) {
        self.id = id
        self.color = color
        self.position = position
    }
}
