//
//  GameView.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 15/09/2025.
//

import Foundation
import SwiftUI
import SpriteKit

class BreakoutScene: SKScene, SKPhysicsContactDelegate {
    let gameSize = CGSize(width: 320, height: 480)
    let sprites: [NodeNames: SKNode] = [
        .paddle: PaddleSprite(position: CGPoint(x: 160, y: 40)),
        .brickLayout: ClassicBricksLayout(),
        .scoreLabel: ScoreLabel(position: CGPoint(x: 40, y: 460)),
        .livesLabel: LivesLabel(position: CGPoint(x: 280, y: 460)),
        .ball: BallSprite(position: CGPoint(x: 160, y: 50)),
        .topWall: WallNode(position: CGPoint(x: 160, y: 430), size: CGSize(width: 320, height: 10)),
        .leftWall: WallNode(position: CGPoint(x: 0, y: 240), size: CGSize(width: 10, height: 480)),
        .rightWall: WallNode(position: CGPoint(x: 320, y: 240), size: CGSize(width: 10, height: 480)),
        .gutter: GutterNode(position: CGPoint(x: 160, y: 0), size: CGSize(width: 320, height: 10))
    ]
    
    override init() {
        super.init(size: CGSize(width: 320, height: 480))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        view.showsPhysics = true
        view.showsFPS = true
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        sprites.values.forEach { addChild($0) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let ball = sprites[.ball] as? BallSprite,
              let paddle = sprites[.paddle] as? PaddleSprite,
              let ballPhysics = ball.physicsBody else { return }
        
        let ballVelocity = ballPhysics.velocity
        
        // Only move paddle if ball is moving downward
        if ballVelocity.dy < 0 {
            // Calculate where ball will be when it reaches paddle y-level
            let timeToReachPaddle = (ball.position.y - paddle.position.y) / abs(ballVelocity.dy)
            let futureX = ball.position.x + (ballVelocity.dx * timeToReachPaddle)
            
            // Move paddle towards predicted ball position
            let paddleSpeed: CGFloat = 450
            let targetX = max(30, min(290, futureX)) // Keep paddle within bounds
            let currentX = paddle.position.x
            
            if abs(targetX - currentX) > 5 {
                let direction = targetX > currentX ? 1 : -1
                let newX = currentX + (CGFloat(direction) * paddleSpeed * 1/60) // Assuming 60 FPS
                paddle.position.x = max(30, min(290, newX))
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        // Check if one of the nodes is a ball and the other is a brick
        if let ball = nodeA as? BallSprite, let brick = nodeB as? BrickSprite {
            print("brick hit at (\(brick.position.x), \(brick.position.y))")
            brick.removeFromParent()
        } else if let ball = nodeB as? BallSprite, let brick = nodeA as? BrickSprite {
            print("brick hit at (\(brick.position.x), \(brick.position.y))")
            brick.removeFromParent()
        }
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
