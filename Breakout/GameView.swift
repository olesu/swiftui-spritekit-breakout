//
//  GameView.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 15/09/2025.
//

import Foundation
import SwiftUI
import SpriteKit

enum NodeNames: String {
    case paddle
    case brickLayout
}

class PaddleSprite: SKSpriteNode {
    init(position: CGPoint) {
        let paddleSize = CGSize(width: 60, height: 12)
        super.init(texture: nil, color: .white, size: paddleSize)
        self.name = NodeNames.paddle.rawValue
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BallSprite: SKSpriteNode {
    
}

class BrickSprite: SKSpriteNode {
    init(position: CGPoint, color: NSColor) {
        let brickSize = CGSize(width: 30, height: 12)
        super.init(texture: nil, color: color, size: brickSize)
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ClassicBricksLayout: SKNode {
    override init() {
        super.init()
        setupBricks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBricks() {
        let brickColors: [NSColor] = [.red, .orange, .yellow, .green, .blue, .purple]
        let bricksPerRow = 10
        let brickWidth: CGFloat = 30
        let brickHeight: CGFloat = 12
        let spacing: CGFloat = 2
        let totalWidth = CGFloat(bricksPerRow) * brickWidth + CGFloat(bricksPerRow - 1) * spacing
        let startX = (320 - totalWidth) / 2 + brickWidth / 2
        
        for row in 0..<6 {
            let color = brickColors[row]
            for col in 0..<bricksPerRow {
                let x = startX + CGFloat(col) * (brickWidth + spacing)
                let y = CGFloat(row) * (brickHeight + spacing) + 350
                let brick = BrickSprite(position: CGPoint(x: x, y: y), color: color)
                addChild(brick)
            }
        }
    }
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
    let sprites: [NodeNames: SKNode] = [
        .paddle: PaddleSprite(position: CGPoint(x: 160, y: 40)),
        .brickLayout: ClassicBricksLayout()
    ]
    
    override init() {
        super.init(size: CGSize(width: 320, height: 480))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        sprites.values.forEach { addChild($0) }
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
            .ignoresSafeArea()
    }
}

#Preview {
    GameView()
}
