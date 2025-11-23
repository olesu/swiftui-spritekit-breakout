import Foundation
import SpriteKit
import AppKit

internal final class GameScene: SKScene, SKPhysicsContactDelegate {
    private let gameNodes: [NodeNames: SKNode]
    private let onGameEvent: (GameEvent) -> Void
    private var brickNodeManager: BrickNodeManager?
    private let ballResetConfigurator = BallResetConfigurator()
    private let paddleBounceApplier = PaddleBounceApplier()

    internal init(
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

    override internal func didMove(to view: SKView) {
        addGradientBackground()
        physicsWorld.contactDelegate = self
        gameNodes.values.forEach(addChild)

        if let brickLayout = gameNodes[.brickLayout] {
            brickNodeManager = BrickNodeManager(brickLayout: brickLayout)
        }
    }

    private func addGradientBackground() {
        let gradientTexture = createGradientTexture()
        let background = SKSpriteNode(texture: gradientTexture)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }

    private func createGradientTexture() -> SKTexture {
        let size = self.size
        let image = NSImage(size: size, flipped: false) { rect in
            let colors = [
                NSColor(red: 0x1a / 255, green: 0x1a / 255, blue: 0x2e / 255, alpha: 1.0),
                NSColor(red: 0x16 / 255, green: 0x21 / 255, blue: 0x3e / 255, alpha: 1.0)
            ]
            let gradient = NSGradient(colors: colors)!
            gradient.draw(
                from: CGPoint(x: 0, y: size.height),
                to: CGPoint(x: 0, y: 0),
                options: []
            )
            return true
        }
        return SKTexture(image: image)
    }

}

// MARK: - UI Updates
extension GameScene {
    internal func updateScore(_ score: Int) {
        if let scoreLabel = gameNodes[.scoreLabel] as? ScoreLabel {
            scoreLabel.text = String(format: "%02d", score)
        }
    }

    internal func updateLives(_ lives: Int) {
        if let livesLabel = gameNodes[.livesLabel] as? LivesLabel {
            livesLabel.text = "\(lives)"
        }
    }
}

// MARK: - Physics Contact Delegate
extension GameScene {
    internal func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // Ball + Brick collision
        if contactMask == (CollisionCategory.ball.mask | CollisionCategory.brick.mask) {
            let brickNode = contact.bodyA.categoryBitMask == CollisionCategory.brick.mask ? contact.bodyA.node : contact.bodyB.node

            if let brickIdString = brickNode?.name {
                let brickId = BrickId(of: brickIdString)
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

    internal func movePaddle(to location: CGPoint) {
        guard let paddle = gameNodes[.paddle] else { return }
        paddle.position.x = paddleClampedX(location: location)
    }
}

// MARK: - Ball Control
extension GameScene {
    internal func resetBall() {
        guard let ball = gameNodes[.ball] else { return }

        ballResetConfigurator.prepareForReset(ball)

        let waitAction = SKAction.wait(forDuration: 0.5)
        let resetAction = SKAction.run { [weak ball, ballResetConfigurator] in
            guard let ball = ball else { return }
            ballResetConfigurator.performReset(ball)
        }

        ball.run(SKAction.sequence([waitAction, resetAction]))
    }

    private func adjustBallVelocityForPaddleHit() {
        guard let ball = gameNodes[.ball],
              let paddle = gameNodes[.paddle] else { return }

        paddleBounceApplier.applyBounce(ball: ball, paddle: paddle)
    }
}

