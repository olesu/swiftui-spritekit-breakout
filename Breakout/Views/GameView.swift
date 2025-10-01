import Foundation
import SwiftUI
import SpriteKit

class BreakoutScene: SKScene, SKPhysicsContactDelegate {
    let gameSize = CGSize(width: 320, height: 480)
    let sprites: [NodeNames: SKNode]
    var autoPaddle: AutoPaddle
    private(set) var autoPaddleConfig: AutoPaddleConfig

    // Callback to notify when a brick is removed
    var onBrickRemoved: (() -> Void) = {}
    var onBallMissed: (() -> Void) = {}

    init(autoPaddleConfig: AutoPaddleConfig = .init(), onBrickAdded: (String) -> ()) {
        self.autoPaddleConfig = autoPaddleConfig

        // Initialize nodes first so we can safely construct AutoPaddle
        let nodes = initNodes(onBrickAdded: onBrickAdded)
        self.sprites = nodes

        // Now that sprites are ready, initialize the auto paddle
        self.autoPaddle = AutoPaddle(
            paddle: nodes[.paddle] as! PaddleSprite,
            ball: nodes[.ball] as! BallSprite,
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
    
    func updateLivesLabel(to value: Int) {
        if let label = sprites[.livesLabel] as? SKLabelNode {
            label.text = "\(value)"
        }
    }
    
    func resetBall() {
        guard let ball = sprites[.ball] as? BallSprite, let body = ball.physicsBody else { return }
        // Reset to initial spawn and relaunch upward
        ball.position = CGPoint(x: 160, y: 50)
        body.velocity = CGVector(dx: 200, dy: 300)
    }
    
    override func update(_ currentTime: TimeInterval) {
        autoPaddle.move()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let ballMask = CollisionCategory.ball.mask
        let brickMask = CollisionCategory.brick.mask
        let gutterMask = CollisionCategory.gutter.mask

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
            onBrickRemoved()
        } else if (otherBody.categoryBitMask & gutterMask) != 0 {
            DispatchQueue.main.async { [weak self] in
                self?.resetBall()
                self?.onBallMissed()
            }
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
    @State private var livesCard = LivesCard(3)
    @State private var scene: BreakoutScene
    @State private var autoPaddleConfig: AutoPaddleConfig
    @State private var bricks: Bricks

    init(initialAutoPaddleConfig: AutoPaddleConfig) {
        self.initialAutoPaddleConfig = initialAutoPaddleConfig
        _autoPaddleConfig = State(initialValue: initialAutoPaddleConfig)

        // Collect bricks during scene creation without capturing self
        var collectedBricks = Bricks()
        let initialScene = BreakoutScene(autoPaddleConfig: initialAutoPaddleConfig, onBrickAdded: { brickName in
            collectedBricks.add(Brick(id: BrickId(of: brickName)))
        })

        _scene = State(initialValue: initialScene)
        _bricks = State(initialValue: collectedBricks)
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

                // Initialize HUD with current score and lives
                scene.updateScoreLabel(to: scoreCard.total)
                scene.updateLivesLabel(to: livesCard.remaining)

                scene.onBallMissed = {
                    DispatchQueue.main.async {
                        // Decrement remaining lives and update HUD
                        livesCard.lifeWasLost()
                        scene.updateLivesLabel(to: livesCard.remaining)
                    }
                }
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
