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

struct BrickData {
    let position: CGPoint
    let color: NSColor
}

class BrickSprite: SKSpriteNode {
    init(position: CGPoint, color: NSColor) {
        let brickSize = CGSize(width: 22, height: 10)
        super.init(texture: nil, color: color, size: brickSize)
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ClassicBricksLayout: SKNode {
    let brickLayout: [BrickData] = [
        // Red row (top)
        BrickData(position: CGPoint(x: 11, y: 420), color: .red),
        BrickData(position: CGPoint(x: 34, y: 420), color: .red),
        BrickData(position: CGPoint(x: 57, y: 420), color: .red),
        BrickData(position: CGPoint(x: 80, y: 420), color: .red),
        BrickData(position: CGPoint(x: 103, y: 420), color: .red),
        BrickData(position: CGPoint(x: 126, y: 420), color: .red),
        BrickData(position: CGPoint(x: 149, y: 420), color: .red),
        BrickData(position: CGPoint(x: 172, y: 420), color: .red),
        BrickData(position: CGPoint(x: 195, y: 420), color: .red),
        BrickData(position: CGPoint(x: 218, y: 420), color: .red),
        BrickData(position: CGPoint(x: 241, y: 420), color: .red),
        BrickData(position: CGPoint(x: 264, y: 420), color: .red),
        BrickData(position: CGPoint(x: 287, y: 420), color: .red),
        BrickData(position: CGPoint(x: 310, y: 420), color: .red),
        // Red row 2
        BrickData(position: CGPoint(x: 11, y: 408), color: .red),
        BrickData(position: CGPoint(x: 34, y: 408), color: .red),
        BrickData(position: CGPoint(x: 57, y: 408), color: .red),
        BrickData(position: CGPoint(x: 80, y: 408), color: .red),
        BrickData(position: CGPoint(x: 103, y: 408), color: .red),
        BrickData(position: CGPoint(x: 126, y: 408), color: .red),
        BrickData(position: CGPoint(x: 149, y: 408), color: .red),
        BrickData(position: CGPoint(x: 172, y: 408), color: .red),
        BrickData(position: CGPoint(x: 195, y: 408), color: .red),
        BrickData(position: CGPoint(x: 218, y: 408), color: .red),
        BrickData(position: CGPoint(x: 241, y: 408), color: .red),
        BrickData(position: CGPoint(x: 264, y: 408), color: .red),
        BrickData(position: CGPoint(x: 287, y: 408), color: .red),
        BrickData(position: CGPoint(x: 310, y: 408), color: .red),
        // Orange row
        BrickData(position: CGPoint(x: 11, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 34, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 57, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 80, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 103, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 126, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 149, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 172, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 195, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 218, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 241, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 264, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 287, y: 396), color: .orange),
        BrickData(position: CGPoint(x: 310, y: 396), color: .orange),
        // Orange row 2
        BrickData(position: CGPoint(x: 11, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 34, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 57, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 80, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 103, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 126, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 149, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 172, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 195, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 218, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 241, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 264, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 287, y: 384), color: .orange),
        BrickData(position: CGPoint(x: 310, y: 384), color: .orange),
        // Yellow row
        BrickData(position: CGPoint(x: 11, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 34, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 57, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 80, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 103, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 126, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 149, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 172, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 195, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 218, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 241, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 264, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 287, y: 372), color: .yellow),
        BrickData(position: CGPoint(x: 310, y: 372), color: .yellow),
        // Yellow row 2
        BrickData(position: CGPoint(x: 11, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 34, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 57, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 80, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 103, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 126, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 149, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 172, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 195, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 218, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 241, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 264, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 287, y: 360), color: .yellow),
        BrickData(position: CGPoint(x: 310, y: 360), color: .yellow),
        // Green row
        BrickData(position: CGPoint(x: 11, y: 348), color: .green),
        BrickData(position: CGPoint(x: 34, y: 348), color: .green),
        BrickData(position: CGPoint(x: 57, y: 348), color: .green),
        BrickData(position: CGPoint(x: 80, y: 348), color: .green),
        BrickData(position: CGPoint(x: 103, y: 348), color: .green),
        BrickData(position: CGPoint(x: 126, y: 348), color: .green),
        BrickData(position: CGPoint(x: 149, y: 348), color: .green),
        BrickData(position: CGPoint(x: 172, y: 348), color: .green),
        BrickData(position: CGPoint(x: 195, y: 348), color: .green),
        BrickData(position: CGPoint(x: 218, y: 348), color: .green),
        BrickData(position: CGPoint(x: 241, y: 348), color: .green),
        BrickData(position: CGPoint(x: 264, y: 348), color: .green),
        BrickData(position: CGPoint(x: 287, y: 348), color: .green),
        BrickData(position: CGPoint(x: 310, y: 348), color: .green),
        // Green row 2
        BrickData(position: CGPoint(x: 11, y: 336), color: .green),
        BrickData(position: CGPoint(x: 34, y: 336), color: .green),
        BrickData(position: CGPoint(x: 57, y: 336), color: .green),
        BrickData(position: CGPoint(x: 80, y: 336), color: .green),
        BrickData(position: CGPoint(x: 103, y: 336), color: .green),
        BrickData(position: CGPoint(x: 126, y: 336), color: .green),
        BrickData(position: CGPoint(x: 149, y: 336), color: .green),
        BrickData(position: CGPoint(x: 172, y: 336), color: .green),
        BrickData(position: CGPoint(x: 195, y: 336), color: .green),
        BrickData(position: CGPoint(x: 218, y: 336), color: .green),
        BrickData(position: CGPoint(x: 241, y: 336), color: .green),
        BrickData(position: CGPoint(x: 264, y: 336), color: .green),
        BrickData(position: CGPoint(x: 287, y: 336), color: .green),
        BrickData(position: CGPoint(x: 310, y: 336), color: .green)
    ]
    
    override init() {
        super.init()
        setupBricks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBricks() {
        brickLayout.forEach { brickData in
            let brick = BrickSprite(position: brickData.position, color: brickData.color)
            addChild(brick)
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
