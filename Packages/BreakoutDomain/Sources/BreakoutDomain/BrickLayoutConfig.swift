import Foundation

/// Represents a positioned brick with its color.
public struct BrickLayoutData {
    public let position: CGPoint
    public let color: BrickColor
}

/// Configuration for a brick type, specifying its visual appearance and point value.
public struct BrickTypeConfig: Codable {
    public let id: Int
    public let colorName: String
    public let scoreValue: Int

    /// Public initializer to allow construction from other modules.
    public init(id: Int, colorName: String, scoreValue: Int) {
        self.id = id
        self.colorName = colorName
        self.scoreValue = scoreValue
    }

    /// Converts the string color name to a domain BrickColor enum.
    /// - Returns: The corresponding BrickColor.
    /// - Throws: BrickColorError if the color name is invalid.
    public func toBrickColor() throws -> BrickColor {
        return try BrickColor(from: colorName)
    }
}

/// Configuration for a brick layout loaded from JSON.
///
/// Represents a grid-based brick layout with positioning metadata.
/// The layout array contains brick type IDs (0 = empty, >0 = brick type).
public struct BrickLayoutConfig: Codable {
    public let levelName: String
    public let mapCols: Int
    public let mapRows: Int
    public let startX: CGFloat
    public let startY: CGFloat
    public let brickWidth: CGFloat
    public let brickHeight: CGFloat
    public let spacing: CGFloat
    public let rowSpacing: CGFloat
    public let brickTypes: [BrickTypeConfig]
    public let layout: [Int]

    /// Public initializer to allow construction from other modules.
    public init(
        levelName: String,
        mapCols: Int,
        mapRows: Int,
        startX: CGFloat,
        startY: CGFloat,
        brickWidth: CGFloat,
        brickHeight: CGFloat,
        spacing: CGFloat,
        rowSpacing: CGFloat,
        brickTypes: [BrickTypeConfig],
        layout: [Int]
    ) {
        self.levelName = levelName
        self.mapCols = mapCols
        self.mapRows = mapRows
        self.startX = startX
        self.startY = startY
        self.brickWidth = brickWidth
        self.brickHeight = brickHeight
        self.spacing = spacing
        self.rowSpacing = rowSpacing
        self.brickTypes = brickTypes
        self.layout = layout
    }
}

public extension BrickLayoutConfig {
    /// Generates positioned brick data from a grid-based layout configuration.
    ///
    /// Converts a one-dimensional layout array representing a 2D grid into positioned
    /// bricks with colors. Skips empty cells (type ID = 0) and calculates positions
    /// based on grid indices and spacing configuration.
    ///
    /// - Parameter config: The layout configuration containing grid data and positioning.
    /// - Returns: An array of brick layout data with calculated positions and colors.
    /// - Throws: BrickColorError if a brick type has an invalid color name.
    static public func generateBricks(from config: BrickLayoutConfig) throws -> [BrickLayoutData] {
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
