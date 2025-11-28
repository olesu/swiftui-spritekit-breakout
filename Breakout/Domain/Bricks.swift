import Foundation

/// Unique identifier for a brick in the game.
internal struct BrickId: Hashable {
    internal let value: String

    internal init(of value: String) {
        self.value = value
    }
}

/// Color of a brick, which determines its visual appearance and point value.
internal enum BrickColor {
    case red
    case orange
    case yellow
    case green

    internal enum ColorError: Error {
        case unknownColor(String)
    }

    /// Creates a brick color from a string name.
    /// - Parameter colorName: The string name of the color (e.g., "Red", "Orange").
    /// - Throws: ColorError.unknownColor if the color name is not recognized.
    init(from colorName: String) throws {
        switch colorName {
        case "Red": self = .red
        case "Orange": self = .orange
        case "Yellow": self = .yellow
        case "Green": self = .green
        default: throw ColorError.unknownColor(colorName)
        }
    }

    /// The point value awarded for destroying a brick of this color.
    internal var pointValue: Int {
        switch self {
        case .red: return 7
        case .orange: return 7
        case .yellow: return 4
        case .green: return 1
        }
    }
}

/// Represents a single brick in the game.
internal struct Brick: Equatable {
    internal let id: BrickId
    internal let color: BrickColor
    internal var value: Int {
        color.pointValue
    }

    internal init(id: BrickId, color: BrickColor = .green) {
        self.id = id
        self.color = color
    }
}

/// Registry for managing all bricks in the current game session.
///
/// Maintains a collection of bricks and provides methods for adding,
/// removing, and querying bricks. Used by the game engine to track
/// which bricks remain and determine win conditions.
internal struct Bricks {
    private var bricks: [BrickId: Brick] = [:]

    /// Indicates whether any bricks remain in the game.
    internal var someRemaining: Bool {
        bricks.count > 0
    }

    /// Retrieves a brick by its ID.
    /// - Parameter id: The ID of the brick to retrieve.
    /// - Returns: The brick if found, nil otherwise.
    internal func get(byId id: BrickId) -> Brick? {
        bricks[id]
    }

    /// Adds a brick to the registry.
    /// - Parameter brick: The brick to add.
    internal mutating func add(_ brick: Brick) {
        bricks[brick.id] = brick
    }

    /// Removes a brick from the registry.
    /// - Parameter id: The ID of the brick to remove.
    internal mutating func remove(withId id: BrickId) {
        bricks.removeValue(forKey: id)
    }

    /// Returns all bricks as a dictionary.
    /// - Returns: Dictionary mapping brick IDs to bricks.
    internal func toDictionary() -> [BrickId: Brick] {
        bricks
    }
}
