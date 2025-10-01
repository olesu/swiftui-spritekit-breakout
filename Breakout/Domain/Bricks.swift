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

struct Brick {
    let id: BrickId
    
    init(id: BrickId) {
        self.id = id
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
