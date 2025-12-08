import AppKit
import Foundation
import SpriteKit

internal final class GameScene: SKScene, SKPhysicsContactDelegate {
    private let paddleSpeed = 450.0

    private let gameNodes: [NodeNames: SKNode]
    private let onGameEvent: (GameEvent) -> Void
    private let collisionRouter: CollisionRouter

    private var brickNodeManager: BrickNodeManager?

    internal var onBallResetComplete: (() -> Void)?

    private let ballController: BallController

    private var paddleMotion: PaddleMotionController?
    private var paddleInput: PaddleInputController?
    private let paddleBounceApplier = PaddleBounceApplier()  // TODO: Inject

    private var lastUpdateTime: TimeInterval = 0

    private weak var ballNode: SKSpriteNode?
    private weak var paddleNode: SKSpriteNode?

    internal init(
        size: CGSize,
        nodes: [NodeNames: SKNode],
        onGameEvent: @escaping (GameEvent) -> Void,
        collisionRouter: CollisionRouter
    ) {
        self.gameNodes = nodes
        self.onGameEvent = onGameEvent
        self.ballController = BallController()  // TODO: Inject
        self.collisionRouter = collisionRouter
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
        initPaddleMotionAndInput()
    }

    private func addGameNodes() {
        gameNodes.values.forEach(addChild)
    }

    private func cacheImportantNodes() {
        ballNode = gameNodes[.ball] as? SKSpriteNode
        paddleNode = gameNodes[.paddle] as? SKSpriteNode

        assert(ballNode != nil, "GameScene: Missing .ball in node dictionary")
        assert(
            paddleNode != nil,
            "GameScene: Missing .paddle in node dictionary"
        )
    }

    private func createBrickManagerIfPossible() {
        if let brickLayout = gameNodes[.brickLayout] {
            brickNodeManager = BrickNodeManager(brickLayout: brickLayout)
        }
    }

    private func initPaddleMotionAndInput() {
        guard let paddle = paddleNode else { return }
        let motion = PaddleMotionController(
            paddle: paddle,
            speed: paddleSpeed,
            sceneWidth: size.width
        )

        paddleMotion = motion
        paddleInput = PaddleInputController(motion: motion)
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

// MARK: - Physics Contact Delegate
extension GameScene {
    internal func didBegin(_ contact: SKPhysicsContact) {
        let result = collisionRouter.route(
            Collision(
                categoryA: contact.bodyA.categoryBitMask,
                nodeA: contact.bodyA.node,
                categoryB: contact.bodyB.categoryBitMask,
                nodeB: contact.bodyB.node
            )
        )
        switch result {
        case .ballHitBrick(let brickId):
            handleBallHitBrick(brickId)
        case .ballHitGutter:
            handleBallHitGutter()
        case .ballHitPaddle:
            handleBallHitPaddle()
        case .none:
            break
        }
    }
    
    private func handleBallHitBrick(_ brickId: BrickId) {
        onGameEvent(.brickHit(brickID: brickId))
        brickNodeManager?.remove(brickId: brickId)
    }
    
    private func handleBallHitGutter() {
        onGameEvent(.ballLost)
    }
    
    private func handleBallHitPaddle() {
        adjustBallVelocityForPaddleHit()
    }
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

// Mark: - Paddle Intent API
extension GameScene {
    func movePaddle(to point: CGPoint) {
        paddleInput?.movePaddle(to: point)
    }

    func endPaddleOverride() {
        paddleInput?.endPaddleOverride()
    }

    func pressLeft() {
        paddleInput?.pressLeft()
    }

    func pressRight() {
        paddleInput?.pressRight()
    }

    func releaseLeft() {
        paddleInput?.releaseLeft()
    }

    func releaseRight() {
        paddleInput?.releaseRight()
    }
}
