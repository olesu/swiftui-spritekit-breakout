import Foundation
import SwiftUI
import SpriteKit

class BreakoutScene: SKScene, SKPhysicsContactDelegate {
    let gameSize = CGSize(width: 320, height: 480)
    let sprites: [NodeNames: SKNode] = initNodes()
    let autoPaddle: AutoPaddle

    // Callback to notify when a brick is removed
    var onBrickRemoved: (() -> Void)?

    override init() {
        self.autoPaddle = AutoPaddle(
            paddle: sprites[.paddle] as! PaddleSprite,
            ball: sprites[.ball] as! BallSprite
        )
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
    
    func updateScoreLabel(to value: Int) {
        if let label = sprites[.scoreLabel] as? SKLabelNode {
            label.text = "\(value)"
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        autoPaddle.move()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let ballMask = CollisionCategory.ball.mask
        let brickMask = CollisionCategory.brick.mask

        let a = contact.bodyA
        let b = contact.bodyB

        // Ensure one of the bodies is the ball
        let isBallA = (a.categoryBitMask & ballMask) != 0
        let isBallB = (b.categoryBitMask & ballMask) != 0
        guard isBallA || isBallB else { return }

        // Determine the non-ball body
        let otherBody = isBallA ? b : a

        // If the other body is a brick, remove its node
        if (otherBody.categoryBitMask & brickMask) != 0 {
            otherBody.node?.removeFromParent()
            // Notify SwiftUI that a brick was removed
            onBrickRemoved?()
        }
    }
    
}

struct GameView: View {
    @State private var scoreCard = ScoreCard()
    @State private var scene = BreakoutScene()
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: 320, height: 480)
            .onAppear {
                scene.scaleMode = .aspectFit
                scene.backgroundColor = .black

                scene.onBrickRemoved = {
                    DispatchQueue.main.async {
                        // Increment by 1 each time a brick is removed
                        scoreCard.score(1)
                        // Update the in-scene HUD label
                        scene.updateScoreLabel(to: scoreCard.total)
                    }
                }
                // Initialize HUD with current score
                scene.updateScoreLabel(to: scoreCard.total)
            }
    }
}

#Preview {
    GameView()
}
