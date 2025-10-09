import Foundation
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

