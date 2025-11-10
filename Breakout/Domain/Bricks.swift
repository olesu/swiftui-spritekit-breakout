//
//  Bricks.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 01/10/2025.
//

import Foundation
import AppKit

struct BrickId: Hashable {
    let value: String

    init(of value: String) {
        self.value = value
    }
}

enum BrickColor {
    case red
    case orange
    case yellow
    case green

    var pointValue: Int {
        switch self {
        case .red: return 7
        case .orange: return 7
        case .yellow: return 4
        case .green: return 1
        }
    }

    init?(from nsColor: NSColor) {
        switch nsColor {
        case .red: self = .red
        case .orange: self = .orange
        case .yellow: self = .yellow
        case .green: self = .green
        default: return nil
        }
    }
}

struct Brick {
    let id: BrickId
    let color: BrickColor

    init(id: BrickId, color: BrickColor = .green) {
        self.id = id
        self.color = color
    }
}

struct Bricks {
    var bricks: [BrickId: Brick] = [:]
    
    var someRemaining: Bool {
        bricks.count > 0
    }
    
    mutating func add(_ brick: Brick) {
        bricks[brick.id] = brick
    }

    mutating func remove(withId id: BrickId) {
        bricks.removeValue(forKey: id)
    }
}
