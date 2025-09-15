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
    init() {
        let paddleSize = CGSize(width: 60, height: 12)
        super.init(texture: nil, color: .white, size: paddleSize)
        self.name = "paddle"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    var paddle: PaddleSprite!
    
    override func didMove(to view: SKView) {
        size = gameSize
        setupPaddle()
    }
    
    private func setupPaddle() {
        paddle = PaddleSprite()
        paddle.position = CGPoint(x: gameSize.width / 2, y: 40)
        addChild(paddle)
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
