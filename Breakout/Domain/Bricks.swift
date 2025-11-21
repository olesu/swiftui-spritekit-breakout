//
//  Bricks.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 01/10/2025.
//

import Foundation

internal struct BrickId: Hashable {
    internal let value: String

    internal init(of value: String) {
        self.value = value
    }
}

internal enum BrickColor {
    case red
    case orange
    case yellow
    case green

    internal enum ColorError: Error {
        case unknownColor(String)
    }

    init(from colorName: String) throws {
        switch colorName {
        case "Red": self = .red
        case "Orange": self = .orange
        case "Yellow": self = .yellow
        case "Green": self = .green
        default: throw ColorError.unknownColor(colorName)
        }
    }

    internal var pointValue: Int {
        switch self {
        case .red: return 7
        case .orange: return 7
        case .yellow: return 4
        case .green: return 1
        }
    }
}

internal struct Brick {
    internal let id: BrickId
    internal let color: BrickColor

    internal init(id: BrickId, color: BrickColor = .green) {
        self.id = id
        self.color = color
    }
}

internal struct Bricks {
    private var bricks: [BrickId: Brick] = [:]

    internal var someRemaining: Bool {
        bricks.count > 0
    }

    internal func get(byId id: BrickId) -> Brick? {
        bricks[id]
    }

    internal mutating func add(_ brick: Brick) {
        bricks[brick.id] = brick
    }

    internal mutating func remove(withId id: BrickId) {
        bricks.removeValue(forKey: id)
    }
}
