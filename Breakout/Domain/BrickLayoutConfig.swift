import Foundation
import AppKit

struct BrickTypeConfig {
    let id: Int
    let colorName: String
    let scoreValue: Int

    enum ColorError: Error {
        case unknownColor(String)
    }

    func toNSColor() throws -> NSColor {
        switch colorName {
        case "Red": return .red
        case "Orange": return .orange
        case "Yellow": return .yellow
        case "Green": return .green
        default: throw ColorError.unknownColor(colorName)
        }
    }
}

struct BrickLayoutConfig {
    let levelName: String
    let mapCols: Int
    let mapRows: Int
    let startX: CGFloat
    let startY: CGFloat
    let brickWidth: CGFloat
    let brickHeight: CGFloat
    let spacing: CGFloat
    let rowSpacing: CGFloat
    let brickTypes: [BrickTypeConfig]
    let layout: [Int]

    func generateBricks() throws -> [BrickData] {
        guard let typeId = layout.first, typeId > 0 else {
            return []
        }

        guard let brickType = brickTypes.first(where: { $0.id == typeId }) else {
            return []
        }

        let color = try brickType.toNSColor()
        return [BrickData(position: CGPoint(x: startX, y: startY), color: color)]
    }
}
