import Foundation
import SpriteKit

final class SKGameScene: SKScene {
    private let nodes: SceneNodes
    private let ballLaunchController: BallLaunchController
    private let contactHandler: SKGamePhysicsContactHandler
    private let gameController: GameController

    private var lastUpdateTime: TimeInterval = 0

    init(
        size: CGSize,
        nodes: SceneNodes,
        ballLaunchController: BallLaunchController,
        contactHandler: SKGamePhysicsContactHandler,
        gameController: GameController,
    ) {
        self.nodes = nodes
        self.ballLaunchController = ballLaunchController
        self.contactHandler = contactHandler
        self.gameController = gameController

        super.init(size: size)

        addGameNodes()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SKGameScene {
    override func update(_ currentTime: TimeInterval) {
        guard lastUpdateTime > 0 else {
            lastUpdateTime = currentTime
            return
        }

        gameController.step(deltaTime: currentTime - lastUpdateTime, sceneSize: size)

        lastUpdateTime = currentTime
    }

}

// MARK: - didMove (add nodes)
extension SKGameScene {
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = contactHandler
    }

    private func addGameNodes() {
        addChild(GradientBackground.create(with: size))
        nodes.attach(to: self)
    }

}

// MARK: - Ball Control
extension SKGameScene {
    func launchBall() {
        ballLaunchController.launch(ball: nodes.ball)
    }

}

// MARK: - Paddle Intent API
extension SKGameScene {
    func movePaddle(to point: CGPoint) {
        gameController.movePaddle(to: point, sceneSize: size)
    }

    func endPaddleOverride() {
        gameController.endPaddleOverride()
    }

    func pressLeft() {
        gameController.pressLeft()
    }

    func pressRight() {
        gameController.pressRight()
    }

    func releaseLeft() {
        gameController.releaseLeft()
    }

    func releaseRight() {
        gameController.releaseRight()
    }
}
