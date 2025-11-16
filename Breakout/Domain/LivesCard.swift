//
//  LivesCard.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 28/09/2025.
//

struct LivesCard {
    private(set) var remaining: Int
    var gameOver: Bool { remaining <= 0 }

    init(_ livesToBeginWith: Int) {
        self.remaining = livesToBeginWith
    }

    mutating func lifeWasLost() {
        self.remaining -= 1
    }
}
