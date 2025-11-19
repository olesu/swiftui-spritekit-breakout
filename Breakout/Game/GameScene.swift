import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let gameNodes: [NodeNames: SKNode]
    private let onGameEvent: (GameEvent) -> Void
    private var brickNodeManager: BrickNodeManager?
    private let ballResetConfigurator = BallResetConfigurator()
    private let paddleBounceApplier = PaddleBounceApplier()

    init(
        size: CGSize,
        nodes: [NodeNames: SKNode],
        onGameEvent: @escaping (GameEvent) -> Void
    ) {
        self.gameNodes = nodes
        self.onGameEvent = onGameEvent
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        gameNodes.values.forEach(addChild)

        if let brickLayout = gameNodes[.brickLayout] {
            brickNodeManager = BrickNodeManager(brickLayout: brickLayout)
        }
    }

}

// MARK: - UI Updates
extension GameScene {
    func updateScore(_ score: Int) {
        if let scoreLabel = gameNodes[.scoreLabel] as? ScoreLabel {
            scoreLabel.text = String(format: "%02d", score)
        }
    }

    func updateLives(_ lives: Int) {
        if let livesLabel = gameNodes[.livesLabel] as? LivesLabel {
            livesLabel.text = "\(lives)"
        }
    }
}

// MARK: - Physics Contact Delegate
extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // Ball + Brick collision
        if contactMask == (CollisionCategory.ball.mask | CollisionCategory.brick.mask) {
            let brickNode = contact.bodyA.categoryBitMask == CollisionCategory.brick.mask ? contact.bodyA.node : contact.bodyB.node

            if let brickIdString = brickNode?.name,
               let brickId = UUID(uuidString: brickIdString) {
                onGameEvent(.brickHit(brickID: brickId))
                brickNodeManager?.remove(brickId: brickId)
            }
        }

        // Ball + Gutter collision
        if contactMask == (CollisionCategory.ball.mask | CollisionCategory.gutter.mask) {
            onGameEvent(.ballLost)
        }

        // Ball + Paddle collision
        if contactMask == (CollisionCategory.ball.mask | CollisionCategory.paddle.mask) {
            adjustBallVelocityForPaddleHit()
        }
    }
}

// MARK: - Paddle Control
extension GameScene {
    private func paddleClampedX(location: CGPoint) -> CGFloat {
        let minX: CGFloat = 20
        let maxX: CGFloat = size.width - 20
        return  max(minX, min(maxX, location.x))
    }
    
    func movePaddle(to location: CGPoint) {
        guard let paddle = gameNodes[.paddle] else { return }
        paddle.position.x = paddleClampedX(location: location)
    }
}

// MARK: - Ball Control
extension GameScene {
    func resetBall() {
        guard let ball = gameNodes[.ball] else { return }

        ballResetConfigurator.prepareForReset(ball)

        let waitAction = SKAction.wait(forDuration: 0.5)
        let resetAction = SKAction.run { [weak ball, ballResetConfigurator] in
            guard let ball = ball else { return }
            ballResetConfigurator.performReset(ball)
        }

        ball.run(SKAction.sequence([waitAction, resetAction]))
    }

    func adjustBallVelocityForPaddleHit() {
        guard let ball = gameNodes[.ball],
              let paddle = gameNodes[.paddle] else { return }

        paddleBounceApplier.applyBounce(ball: ball, paddle: paddle)
    }
}

