import Foundation
import SwiftUI
import SpriteKit

class BreakoutScene: SKScene, SKPhysicsContactDelegate {
    let gameSize = CGSize(width: 320, height: 480)
    let sprites: [NodeNames: SKNode] = initNodes()
    var autoPaddle: AutoPaddle
    private(set) var autoPaddleConfig: AutoPaddleConfig

    // Callback to notify when a brick is removed
    var onBrickRemoved: (() -> Void)?

    init(autoPaddleConfig: AutoPaddleConfig = .init()) {
        self.autoPaddleConfig = autoPaddleConfig
        self.autoPaddle = AutoPaddle(
            paddle: sprites[.paddle] as! PaddleSprite,
            ball: sprites[.ball] as! BallSprite,
            config: autoPaddleConfig
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

extension BreakoutScene {
    func apply(autoPaddleConfig: AutoPaddleConfig) {
        self.autoPaddleConfig = autoPaddleConfig
        self.autoPaddle.update(config: autoPaddleConfig)
    }
}

struct GameView: View {
    // External source-of-truth value for preferences
    var initialAutoPaddleConfig: AutoPaddleConfig

    @State private var scoreCard = ScoreCard()
    @State private var scene: BreakoutScene
    @State private var autoPaddleConfig: AutoPaddleConfig

    init(initialAutoPaddleConfig: AutoPaddleConfig) {
        self.initialAutoPaddleConfig = initialAutoPaddleConfig
        _autoPaddleConfig = State(initialValue: initialAutoPaddleConfig)
        _scene = State(initialValue: BreakoutScene(autoPaddleConfig: initialAutoPaddleConfig))
    }
    
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
            .onChange(of: autoPaddleConfig) { _, newValue in
                scene.apply(autoPaddleConfig: newValue)
            }
            .onChange(of: initialAutoPaddleConfig) { _, newValue in
                // Keep internal state in sync with app-level preferences
                autoPaddleConfig = newValue
                scene.apply(autoPaddleConfig: newValue)
            }
    }
}

#Preview {
    GameView(initialAutoPaddleConfig: AutoPaddleConfig())
}
