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
    let gameSize = CGSize(width: 320, height: 480)
    
    override func didMove(to view: SKView) {
        size = gameSize
    }
}

struct GameView: View {
    var breakoutScene: SKScene {
        let scene = BreakoutScene()
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .black
        return scene
    }
    
    var body: some View {
        SpriteView(scene: breakoutScene)
            .frame(width: 320, height: 480)
    }
}

#Preview {
    GameView()
}
