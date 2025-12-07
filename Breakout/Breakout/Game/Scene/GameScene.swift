import AppKit
import Foundation
import SpriteKit

internal final class GameScene: SKScene, SKPhysicsContactDelegate {
    private let gameNodes: [NodeNames: SKNode]

    private var brickNodeManager: BrickNodeManager?

    internal var onBallResetComplete: (() -> Void)?
    private let onGameEvent: (GameEvent) -> Void

    private let ballController: BallController

    private var paddleMotion: PaddleMotionController?
    private let paddleBounceApplier = PaddleBounceApplier()

    private var lastUpdateTime: TimeInterval = 0

    internal init(
        size: CGSize,
        nodes: [NodeNames: SKNode],
        onGameEvent: @escaping (GameEvent) -> Void
    ) {
        self.gameNodes = nodes
        self.onGameEvent = onGameEvent
        self.ballController = BallController()
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func didMove(to view: SKView) {
        addGradientBackground()
        setPhysicsDelegateToSelf()
        initBrickNodeManager()
        initPaddleMotion()
    }
    
    private func setPhysicsDelegateToSelf() {
        physicsWorld.contactDelegate = self
    }
    
    private func initBrickNodeManager() {
        guard let brickLayout = gameNodes[.brickLayout] else {
            return
        }
        
        gameNodes.values.forEach(addChild)
        brickNodeManager = BrickNodeManager(brickLayout: brickLayout)
    }
    
    private func initPaddleMotion() {
        guard let paddle = gameNodes[.paddle] as? SKSpriteNode else {
            assertionFailure("Paddle must be an SKSpriteNode")
            return
        }

        paddleMotion = PaddleMotionController(
            paddle: paddle,
            speed: 450,
            sceneWidth: size.width
        )
    }

    override internal func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            let dt = currentTime - lastUpdateTime
            paddleMotion?.update(deltaTime: dt)
        }

        if let ball = gameNodes[.ball] as? SKSpriteNode,
            let paddle = gameNodes[.paddle] as? SKSpriteNode
        {
            ballController.update(ball: ball, paddle: paddle)
        }
        lastUpdateTime = currentTime
    }

    private func addGradientBackground() {
        addChild(GradientBackground.create(with: size))
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
        let contactMask =
            contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        // Ball + Brick collision
        if contactMask
            == (CollisionCategory.ball.mask | CollisionCategory.brick.mask)
        {
            let brickNode =
                contact.bodyA.categoryBitMask == CollisionCategory.brick.mask
                ? contact.bodyA.node : contact.bodyB.node

            if let brickIdString = brickNode?.name {
                let brickId = BrickId(of: brickIdString)
                onGameEvent(.brickHit(brickID: brickId))
                brickNodeManager?.remove(brickId: brickId)
            }
        }

        // Ball + Gutter collision
        if contactMask
            == (CollisionCategory.ball.mask | CollisionCategory.gutter.mask)
        {
            onGameEvent(.ballLost)
        }

        // Ball + Paddle collision
        if contactMask
            == (CollisionCategory.ball.mask | CollisionCategory.paddle.mask)
        {
            adjustBallVelocityForPaddleHit()
        }
    }
}

// MARK: - Paddle Intents
extension GameScene {
    func startMovingPaddleLeft() { paddleMotion?.startLeft() }
    func startMovingPaddleRight() { paddleMotion?.startRight() }
    func stopMovingPaddle() { paddleMotion?.stop() }
    func movePaddle(to location: CGPoint) {
        paddleMotion?.overridePosition(x: location.x)
    }
    func endPaddleOverride() { paddleMotion?.endOverride() }

}

// MARK: - Ball Control
extension GameScene {
    internal func resetBall() {
        guard
            let ball = gameNodes[.ball] as? SKSpriteNode
        else { return }

        ballController.prepareReset(ball: ball)

        let wait = SKAction.wait(forDuration: 0.5)

        let reset = SKAction.run { [weak self] in
            guard
                let self,
                let ball = self.gameNodes[.ball] as? SKSpriteNode
            else { return }

            let resetPosition = CGPoint(x: 160, y: 50)

            self.ballController.performReset(ball: ball, at: resetPosition)
            self.onBallResetComplete?()
        }

        ball.run(.sequence([wait, reset]))
    }

    internal func launchBall() {
        guard
            let ball = gameNodes[.ball] as? SKSpriteNode
        else { return }

        ballController.launch(ball: ball)
    }

    private func adjustBallVelocityForPaddleHit() {
        guard let ball = gameNodes[.ball],
            let paddle = gameNodes[.paddle]
        else { return }

        paddleBounceApplier.applyBounce(ball: ball, paddle: paddle)
    }
}
