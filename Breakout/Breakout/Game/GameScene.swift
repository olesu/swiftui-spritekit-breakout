import Foundation
import SpriteKit
import AppKit

internal final class GameScene: SKScene, SKPhysicsContactDelegate {
    private let gameNodes: [NodeNames: SKNode]
    private let onGameEvent: (GameEvent) -> Void
    private var brickNodeManager: BrickNodeManager?
    private let ballResetConfigurator = BallResetConfigurator()
    private let paddleBounceApplier = PaddleBounceApplier()
    private var isBallClamped = true
    internal var onBallResetComplete: (() -> Void)?
    
    private var lastUpdateTime: TimeInterval = 0

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

    override internal func update(_ currentTime: TimeInterval) {
        if isBallClamped {
            clampBallToPaddle()
        }
        
        if lastUpdateTime > 0 {
            let dt = currentTime - lastUpdateTime
            tickPaddleMovement(deltaTime: dt)
        }
        lastUpdateTime = currentTime
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
    private func clampedPaddleX(_ x: CGFloat) -> CGFloat {
        guard let paddle = gameNodes[.paddle] else { return x }
        
        let halfWidth = paddle.frame.width / 2
        let minX = halfWidth
        let maxX = size.width - halfWidth
        
        return max(minX, min(maxX, x))
    }

    func movePaddle(to location: CGPoint) {
        guard let paddle = gameNodes[.paddle] else { return }
        paddle.position.x = clampedPaddleX(location.x)
    }
}

// MARK: - Paddle Intents
extension GameScene {
    internal func startMovingPaddleLeft()  { isMovingLeft = true }
    internal func startMovingPaddleRight() { isMovingRight = true }
    internal func stopMovingPaddle() {
        isMovingLeft = false
        isMovingRight = false
    }
}

// MARK: - Paddle Motion State
extension GameScene {
    private var paddleNode: SKNode? { gameNodes[.paddle] }

    private var isMovingLeft: Bool {
        get { paddleMotion.isMovingLeft }
        set { paddleMotion.isMovingLeft = newValue }
    }

    private var isMovingRight: Bool {
        get { paddleMotion.isMovingRight }
        set { paddleMotion.isMovingRight = newValue }
    }
}

// Simple mutable struct to keep state together
private struct PaddleMotion {
    var isMovingLeft = false
    var isMovingRight = false
    let speed: CGFloat = 450.0
}

private var paddleMotion = PaddleMotion()

// MARK: - Temporary tick-based movement (will be replaced)
extension GameScene {
    internal func tickPaddleMovement(deltaTime dt: TimeInterval) {
        guard let paddle = paddleNode else { return }

        var x = paddle.position.x
        if isMovingLeft  { x -= paddleMotion.speed * CGFloat(dt) }
        if isMovingRight { x += paddleMotion.speed * CGFloat(dt) }

        paddle.position.x = clampedPaddleX(x) // already refactored
    }
}


// MARK: - Ball Control
extension GameScene {
    internal func resetBall() {
        guard let ball = gameNodes[.ball] else { return }

        ballResetConfigurator.prepareForReset(ball)
        isBallClamped = true

        let waitAction = SKAction.wait(forDuration: 0.5)
        let resetAction = SKAction.run { [weak ball, weak self, ballResetConfigurator] in
            guard let ball = ball else { return }
            ballResetConfigurator.performReset(ball)
            self?.clampBallToPaddle()
            self?.onBallResetComplete?()
        }

        ball.run(SKAction.sequence([waitAction, resetAction]))
    }

    internal func launchBall() {
        guard isBallClamped,
              let ball = gameNodes[.ball],
              let ballBody = ball.physicsBody else { return }

        isBallClamped = false
        ballBody.velocity = CGVector(dx: 0, dy: 360)
    }

    private func clampBallToPaddle() {
        guard let ball = gameNodes[.ball],
              let paddle = gameNodes[.paddle] else { return }

        let paddleTop = paddle.position.y + paddle.frame.height / 2
        let ballRadius = ball.frame.width / 2
        ball.position = CGPoint(
            x: paddle.position.x,
            y: paddleTop + ballRadius
        )
    }

    private func adjustBallVelocityForPaddleHit() {
        guard let ball = gameNodes[.ball],
              let paddle = gameNodes[.paddle] else { return }

        paddleBounceApplier.applyBounce(ball: ball, paddle: paddle)
    }
}

