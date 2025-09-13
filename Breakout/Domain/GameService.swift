//
//  GameService.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 23/08/2025.
//

import Foundation

protocol GameService {
    var state: GameState { get }
    var score: Int { get }
    var remainingLives: Int { get }
    var bricks: [Brick] { get }

    // Game loop entry point
    func launchBall()

    // Events from SpriteKit
    func ballHitBrick(_ brick: Brick)
    func ballHitBottom()
}
