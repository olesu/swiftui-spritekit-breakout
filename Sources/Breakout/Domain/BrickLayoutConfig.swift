import Foundation

/// Represents a positioned brick with its color.
internal struct BrickLayoutData {
    internal let position: CGPoint
    internal let color: BrickColor
}

/// Configuration for a brick type, specifying its visual appearance and point value.
internal struct BrickTypeConfig: Codable {
    internal let id: Int
    internal let colorName: String
    internal let scoreValue: Int

    /// Converts the string color name to a domain BrickColor enum.
    /// - Returns: The corresponding BrickColor.
    /// - Throws: BrickColorError if the color name is invalid.
    internal func toBrickColor() throws -> BrickColor {
        return try BrickColor(from: colorName)
    }
}

/// Configuration for a brick layout loaded from JSON.
///
/// Represents a grid-based brick layout with positioning metadata.
/// The layout array contains brick type IDs (0 = empty, >0 = brick type).
internal struct BrickLayoutConfig: Codable {
    internal let levelName: String
    internal let mapCols: Int
    internal let mapRows: Int
    internal let startX: CGFloat
    internal let startY: CGFloat
    internal let brickWidth: CGFloat
    internal let brickHeight: CGFloat
    internal let spacing: CGFloat
    internal let rowSpacing: CGFloat
    internal let brickTypes: [BrickTypeConfig]
    internal let layout: [Int]
}

extension BrickLayoutConfig {
    /// Generates positioned brick data from a grid-based layout configuration.
    ///
    /// Converts a one-dimensional layout array representing a 2D grid into positioned
    /// bricks with colors. Skips empty cells (type ID = 0) and calculates positions
    /// based on grid indices and spacing configuration.
    ///
    /// - Parameter config: The layout configuration containing grid data and positioning.
    /// - Returns: An array of brick layout data with calculated positions and colors.
    /// - Throws: BrickColorError if a brick type has an invalid color name.
    static internal func generateBricks(from config: BrickLayoutConfig) throws -> [BrickLayoutData] {
        var bricks: [BrickLayoutData] = []

        for (index, typeId) in config.layout.enumerated() {
            guard typeId > 0 else { continue }

            guard let brickType = config.brickTypes.first(where: { $0.id == typeId }) else {
                continue
            }

            let row = index / config.mapCols
            let col = index % config.mapCols

            let x = config.startX + CGFloat(col) * (config.brickWidth + config.spacing)
            let y = config.startY - CGFloat(row) * config.rowSpacing

            let color = try brickType.toBrickColor()
            bricks.append(BrickLayoutData(position: CGPoint(x: x, y: y), color: color))
        }

        return bricks
    }
}
