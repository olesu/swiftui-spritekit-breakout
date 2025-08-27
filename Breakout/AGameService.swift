//
//  AGameService.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 23/08/2025.
//

import Foundation

class AGameService: GameService {
    var state: GameState = .ready
    var score: Int
    var remainingLives: Int
    var bricks: [Brick]
    
    init(remainingLives: Int = 0,
         bricks: [Brick] = [],
         score: Int = 0
    ) {
        self.remainingLives = remainingLives
        self.bricks = bricks
        self.score = score
    }

    func launchBall() {
        if state != .ready { return }

        if remainingLives <= 0 {
            state = .gameOver
        } else {
            state = .playing
        }
    }
    
    func ballHitBottom() {
        self.remainingLives -= 1
        if self.remainingLives <= 0 {
            state = .gameOver
        } else {
            state = .ready
        }
    }
    
    func ballHitBrick(_ brick: Brick) {
        if state != .playing { return }
        
        if !bricks.contains(where: { $0.id == brick.id }) {
            return
        }
        
        bricks.removeAll { $0.id == brick.id }
        score += 1

        if bricks.isEmpty {
            state = .won
        }
    }
    
}
