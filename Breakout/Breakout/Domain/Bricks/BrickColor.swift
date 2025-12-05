import Foundation

/// Color of a brick, which determines its visual appearance and point value.
nonisolated enum BrickColor {
    case red
    case orange
    case yellow
    case green

    enum ColorError: Error {
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
    var pointValue: Int {
        switch self {
        case .red: return 7
        case .orange: return 7
        case .yellow: return 4
        case .green: return 1
        }
    }
}

