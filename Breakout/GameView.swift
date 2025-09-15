//
//  GameView.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 15/09/2025.
//

import Foundation
import SwiftUI
import SpriteKit

class PaddleSprite: SKSpriteNode {
    
}

class BallSprite: SKSpriteNode {
    
}

class BrickSprite: SKSpriteNode {
    
}

class ScoreLabel: SKLabelNode {
    
}

class LivesLabel: SKLabelNode {
    
}

class WallNode: SKNode {
    
}

class GutterNode: SKNode {
    
}

class BreakoutScene: SKScene {
    override func didMove(to view: SKView) {
        
    }
}

struct GameView: View {
    var breakoutScene: SKScene {
        BreakoutScene()
    }
    
    var body: some View {
        SpriteView(scene: breakoutScene)
    }
}

#Preview {
    GameView()
}
