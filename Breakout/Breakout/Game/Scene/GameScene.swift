import AppKit
import Foundation
import SpriteKit

internal final class GameScene: SKScene, SKPhysicsContactDelegate {
    private let paddleSpeed = 450.0
    private let gameNodes: [NodeNames: SKNode]

    private var brickNodeManager: BrickNodeManager?

    internal var onBallResetComplete: (() -> Void)?
    private let onGameEvent: (GameEvent) -> Void

    private let ballController: BallController

    private var paddleMotion: PaddleMotionController?
    private let paddleBounceApplier = PaddleBounceApplier()

    private var lastUpdateTime: TimeInterval = 0
    
    private weak var ballNode: SKSpriteNode?
    private weak var paddleNode: SKSpriteNode?

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

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        addGameNodes()
        addGradientBackground()
        cacheImportantNodes()
        createBrickManagerIfPossible()
        initPaddleMotion()
    }

    private func addGameNodes() {
        gameNodes.values.forEach(addChild)
    }

    private func cacheImportantNodes() {
        ballNode = gameNodes[.ball] as? SKSpriteNode
        paddleNode = gameNodes[.paddle] as? SKSpriteNode

        assert(ballNode != nil, "GameScene: Missing .ball in node dictionary")
        assert(paddleNode != nil, "GameScene: Missing .paddle in node dictionary")
    }

    private func createBrickManagerIfPossible() {
        if let brickLayout = gameNodes[.brickLayout] {
            brickNodeManager = BrickNodeManager(brickLayout: brickLayout)
        }
    }

    private func initPaddleMotion() {
        guard let paddle = paddleNode else { return }
        paddleMotion = PaddleMotionController(
            paddle: paddle,
            speed: paddleSpeed,
            sceneWidth: size.width
        )
    }

    override internal func update(_ currentTime: TimeInterval) {
        guard lastUpdateTime > 0 else {
            lastUpdateTime = currentTime
            return
        }

        let dt = currentTime - lastUpdateTime
        paddleMotion?.update(deltaTime: dt)

        if let ball = ballNode,
            let paddle = paddleNode
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
        // TODO: Improve with reducer
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
// TODO: Extract protocol
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
            let ball = ballNode
        else { return }

        ballController.prepareReset(ball: ball)

        let wait = SKAction.wait(forDuration: 0.5)

        let reset = SKAction.run { [weak self] in
            guard
                let self,
                let ball = self.ballNode
            else { return }

            self.ballController.performReset(ball: ball, at: resetPosition())
            self.onBallResetComplete?()
        }

        run(.sequence([wait, reset]))
    }
    
    private func resetPosition() -> CGPoint {
        .init(x: size.width / 2, y: 50)
    }

    internal func launchBall() {
        guard
            let ball = ballNode
        else { return }

        ballController.launch(ball: ball)
    }

    private func adjustBallVelocityForPaddleHit() {
        guard let ball = ballNode,
            let paddle = paddleNode
        else { return }

        paddleBounceApplier.applyBounce(ball: ball, paddle: paddle)
    }
}
