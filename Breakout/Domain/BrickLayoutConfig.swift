import Foundation

internal struct BrickLayoutData {
    internal let position: CGPoint
    internal let color: BrickColor
}

internal struct BrickTypeConfig: Codable {
    internal let id: Int
    internal let colorName: String
    internal let scoreValue: Int

    internal enum ColorError: Error {
        case unknownColor(String)
    }

    // TODO: Move to BrickColor.init(from colorName: String)
    internal func toBrickColor() throws -> BrickColor {
        switch colorName {
        case "Red": return .red
        case "Orange": return .orange
        case "Yellow": return .yellow
        case "Green": return .green
        default: throw ColorError.unknownColor(colorName)
        }
    }
}

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
