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
    let sprites: [NodeNames: SKSpriteNode] = [
        .paddle: PaddleSprite(position: CGPoint(x: 160, y: 40))
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
    }
}

#Preview {
    GameView()
}
