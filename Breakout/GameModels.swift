//
//  GameModels.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 23/08/2025.
//

import Foundation
import CoreGraphics

struct Brick: Identifiable {
    let id: UUID
}

struct Paddle {
    var position: CGPoint = CGPoint(x: 200, y: 50)
    var size: CGSize = CGSize(width: 80, height: 16)
}
