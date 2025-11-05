//
//  Bricks.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 01/10/2025.
//

import Foundation

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
