//
//  GameState.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 23/08/2025.
//

import Foundation

enum GameState: Equatable {
    case ready   // ball on paddle
    case playing
    case gameOver
    case won
}
