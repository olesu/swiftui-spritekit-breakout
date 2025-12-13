import AppKit
import Foundation
import SpriteKit

internal final class GameScene: SKScene, SKPhysicsContactDelegate {
    private let collisionRouter: CollisionRouter
    private let nodeManager: NodeManager
    private let gameSession: GameSession
    private let ballLaunchController: BallLaunchController
    private let ballMotionController: BallMotionController
    private let paddleMotionController: PaddleMotionController
    private let paddleInputController: PaddleInputController
    private let paddleBounceApplier: PaddleBounceApplier

    private var lastUpdateTime: TimeInterval = 0
    private var localResetInProgress: Bool = false

    internal init(
        size: CGSize,
        collisionRouter: CollisionRouter,
        paddleMotionController: PaddleMotionController,
        gameSession: GameSession,
        nodeManager: NodeManager,
        ballLaunchController: BallLaunchController,
        ballMotionController: BallMotionController,
        paddleInputController: PaddleInputController,
        paddleBounceApplier: PaddleBounceApplier
    ) {
        self.nodeManager = nodeManager
        self.ballLaunchController = ballLaunchController
        self.ballMotionController = ballMotionController
        self.collisionRouter = collisionRouter
        self.paddleMotionController = paddleMotionController
        self.gameSession = gameSession
        self.paddleInputController = paddleInputController
        self.paddleBounceApplier = paddleBounceApplier
        
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GameScene {
    override internal func update(_ currentTime: TimeInterval) {
        guard lastUpdateTime > 0 else {
            lastUpdateTime = currentTime
            return
        }

        let dt = currentTime - lastUpdateTime
        let resetNeeded = gameSession.state.ballResetNeeded

        if resetNeeded && !localResetInProgress {
            localResetInProgress = true
            gameSession.announceBallResetInProgress()
            resetBall()
        }

        if !localResetInProgress {
            updateBallAndPaddle(deltaTime: dt)
        }

        lastUpdateTime = currentTime
    }

    private func updateBallAndPaddle(deltaTime dt: TimeInterval) {
        paddleMotionController.update(deltaTime: dt)
        nodeManager.paddle.position.x = CGFloat(paddleMotionController.paddle.x)
        ballLaunchController.update(ball: nodeManager.ball, paddle: nodeManager.paddle)
    }
}

// MARK: - didMove (add nodes)
extension GameScene {
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        addGameNodes()
    }

    private func addGameNodes() {
        addChild(GradientBackground.create(with: size))
        
        addChild(nodeManager.topWall)
        addChild(nodeManager.leftWall)
        addChild(nodeManager.rightWall)
        addChild(nodeManager.gutter)
        
        addChild(nodeManager.bricks)
        
        addChild(nodeManager.paddle)
        addChild(nodeManager.ball)

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
        gameSession.apply(.brickHit(brickID: brickId))
        nodeManager.remove(brickId: brickId)
    }

    private func handleBallHitGutter() {
        gameSession.apply(.ballLost)
    }

    private func handleBallHitPaddle() {
        adjustBallVelocityForPaddleHit()
    }
}

// MARK: - Ball Control
extension GameScene {
    internal func resetBall() {
        ballLaunchController.prepareReset(ball: nodeManager.ball)

        //        let wait = SKAction.wait(forDuration: 0.5)

        let reset = SKAction.run { [weak self] in
            guard
                let self
            else { return }

            self.ballLaunchController.performReset(ball: nodeManager.ball, at: resetPosition())

            gameSession.acknowledgeBallReset()
            localResetInProgress = false
        }

        run(.sequence([ /*wait,*/reset]))
    }

    private func resetPosition() -> CGPoint {
        .init(x: size.width / 2, y: 50)
    }

    internal func launchBall() {
        ballLaunchController.launch(ball: nodeManager.ball)
    }

    private func adjustBallVelocityForPaddleHit() {
        ballMotionController.update(ball: nodeManager.ball, speedMultiplier: 1.03)
        paddleBounceApplier.applyBounce(ball: nodeManager.ball, paddle: nodeManager.paddle)
    }
}

// Mark: - Paddle Intent API
extension GameScene {
    func movePaddle(to point: CGPoint) {
        paddleInputController.movePaddle(to: point)
    }

    func endPaddleOverride() {
        paddleInputController.endPaddleOverride()
    }

    func pressLeft() {
        paddleInputController.pressLeft()
    }

    func pressRight() {
        paddleInputController.pressRight()
    }

    func releaseLeft() {
        paddleInputController.releaseLeft()
    }

    func releaseRight() {
        paddleInputController.releaseRight()
    }
}
