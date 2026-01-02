import Foundation
import SpriteKit

final class SKNodeManager: NodeManager {
    private let ballLaunchController: BallLaunchController
    private let paddleMotionController: PaddleMotionController
    private let paddleBounceApplier: PaddleBounceApplier

    let nodes: SceneNodes

    var removalQueue: Set<BrickId> = []

    var lastBrickHitPosition: CGPoint?

    init(
        ballLaunchController: BallLaunchController,
        paddleMotionController: PaddleMotionController,
        paddleBounceApplier: PaddleBounceApplier,
        nodes: SceneNodes
    ) {
        self.ballLaunchController = ballLaunchController
        self.paddleMotionController = paddleMotionController
        self.paddleBounceApplier = paddleBounceApplier
        self.nodes = nodes
    }

    func enqueueRemoval(of brickId: BrickId) {
        guard let brick = findBrick(brickId) else { return }

        lastBrickHitPosition = brick.position
        removalQueue.insert(brickId)
    }

    func removeEnqueued() {
        removalQueue.forEach {
            handleBrickRemoval($0)
        }
        removalQueue.removeAll()
    }

    func moveBall(to position: Point) {
        nodes.ball.setPosition(position)
    }

    func resetBall(sceneSize: Size) {
        ballLaunchController.performReset(
            ball: nodes.ball,
            at: Point(x: sceneSize.width / 2, y: 50)
        )
    }

    func update(
        deltaTime dt: TimeInterval,
        sceneSize: Size
    ) {
        let newPaddle = paddleMotionController.update(
            paddle: Paddle(
                position: nodes.paddle.position,
                width: nodes.paddle.size.width
            ),
            deltaTime: dt,
            sceneSize: CGSize(sceneSize)
        )
        nodes.paddle.setPosition(newPaddle.position)
        ballLaunchController.update(ball: nodes.ball, paddle: nodes.paddle)
    }

    func beginPaddleKeyboardOverride(to position: CGPoint, sceneSize: CGSize) {
        let newPaddle = paddleMotionController.overridePosition(
            paddle: Paddle(
                position: nodes.paddle.position,
                width: nodes.paddle.size.width
            ),
            x: position.x,
            sceneSize: sceneSize
        )
        nodes.paddle.setPosition(newPaddle.position)

    }

    func endPaddleKeyboardOverride() {
        paddleMotionController.endOverride()
    }

    func startPaddleLeft() {
        paddleMotionController.startLeft()
    }

    func startPaddleRight() {
        paddleMotionController.startRight()
    }

    func stopPaddle() {
        paddleMotionController.stop()
    }

    func ballHitPaddle() {
        paddleBounceApplier.applyBounce(ball: nodes.ball, paddle: nodes.paddle)

    }

    func resetBricks() {
        
    }
    
}

// MARK: Handle Brick Removal
extension SKNodeManager {
    private func handleBrickRemoval(_ brickId: BrickId) {
        guard let brickToRemove = findBrick(brickId) else {
            return
        }
        remove(node: brickToRemove)

    }

    private func findBrick(_ brickId: BrickId) -> SKNode? {
        nodes.bricks.children.first {
            $0.name == brickId.value
        }
    }

    private func remove(node: SKNode) {
        node.removeFromParent()
    }
}
