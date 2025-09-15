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
    case scoreLabel
    case livesLabel
    case ball
    case topWall
    case leftWall
    case rightWall
    case gutter
}

class PaddleSprite: SKSpriteNode {
    init(position: CGPoint) {
        let paddleSize = CGSize(width: 60, height: 12)
        super.init(texture: nil, color: .white, size: paddleSize)
        self.name = NodeNames.paddle.rawValue
        self.position = position
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: paddleSize)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = 16
        self.physicsBody?.contactTestBitMask = 4
        self.physicsBody?.collisionBitMask = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BallSprite: SKSpriteNode {
    init(position: CGPoint) {
        let ballSize = CGSize(width: 8, height: 8)
        super.init(texture: nil, color: .white, size: ballSize)
        self.name = NodeNames.ball.rawValue
        self.position = position
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: ballSize)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = 4
        self.physicsBody?.contactTestBitMask = 1 | 2 | 8 | 16
        self.physicsBody?.collisionBitMask = 1 | 8 | 16
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.affectedByGravity = false
        
        // Set initial velocity (diagonal up and right)
        self.physicsBody?.velocity = CGVector(dx: 200, dy: 300)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = 8
        self.physicsBody?.contactTestBitMask = 4
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
    init(position: CGPoint) {
        super.init()
        self.text = "00"
        self.fontName = "Courier-Bold"
        self.fontSize = 20
        self.fontColor = .white
        self.position = position
        self.name = NodeNames.scoreLabel.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LivesLabel: SKLabelNode {
    init(position: CGPoint) {
        super.init()
        self.text = "3"
        self.fontName = "Courier-Bold"
        self.fontSize = 20
        self.fontColor = .white
        self.position = position
        self.name = NodeNames.livesLabel.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WallNode: SKNode {
    init(position: CGPoint, size: CGSize) {
        super.init()
        let wall = SKSpriteNode(color: .clear, size: size)
        wall.physicsBody = SKPhysicsBody(rectangleOf: size)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = 1
        wall.position = position
        addChild(wall)
        self.name = NodeNames.topWall.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GutterNode: SKNode {
    init(position: CGPoint, size: CGSize) {
        super.init()
        let gutter = SKSpriteNode(color: .clear, size: size)
        gutter.physicsBody = SKPhysicsBody(rectangleOf: size)
        gutter.physicsBody?.isDynamic = false
        gutter.physicsBody?.categoryBitMask = 2
        gutter.position = position
        addChild(gutter)
        self.name = NodeNames.gutter.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
