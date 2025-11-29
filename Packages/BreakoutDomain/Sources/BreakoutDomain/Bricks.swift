import Foundation

/// Unique identifier for a brick in the game.
public struct BrickId: Hashable, Sendable {
    public let value: String

    public init(of value: String) {
        self.value = value
    }
}

/// Color of a brick, which determines its visual appearance and point value.
public enum BrickColor: Sendable {
    case red
    case orange
    case yellow
    case green

    public enum ColorError: Error, Sendable {
        case unknownColor(String)
    }

    /// Creates a brick color from a string name.
    /// - Parameter colorName: The string name of the color (e.g., "Red", "Orange").
    /// - Throws: ColorError.unknownColor if the color name is not recognized.
    public init(from colorName: String) throws {
        switch colorName {
        case "Red": self = .red
        case "Orange": self = .orange
        case "Yellow": self = .yellow
        case "Green": self = .green
        default: throw ColorError.unknownColor(colorName)
        }
    }

    /// The point value awarded for destroying a brick of this color.
    public var pointValue: Int {
        switch self {
        case .red: return 7
        case .orange: return 7
        case .yellow: return 4
        case .green: return 1
        }
    }
}

/// Represents a single brick in the game.
public struct Brick: Equatable, Sendable {
    public let id: BrickId
    public let color: BrickColor
    public var value: Int {
        color.pointValue
    }

    public init(id: BrickId, color: BrickColor = .green) {
        self.id = id
        self.color = color
    }
}
