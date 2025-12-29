import Foundation
import SpriteKit

final class SKNodeManager: NodeManager {
    private let ballLaunchController: BallLaunchController
    private let paddleMotionController: PaddleMotionController
    private let paddleBounceApplier: PaddleBounceApplier

    let nodes: SceneNodes

    var removalQueue: Set<BrickId> = []

    var lastBrickHitPosition: CGPoint? = nil
    
    init(
        ballLaunchController: BallLaunchController,
        paddleMotionController: PaddleMotionController,
        paddleBounceApplier: PaddleBounceApplier,
        brickLayoutFactory: BrickLayoutFactory,
        nodes: SceneNodes
    ) {
        self.ballLaunchController = ballLaunchController
        self.paddleMotionController = paddleMotionController
        self.paddleBounceApplier = paddleBounceApplier
        self.nodes = nodes
    }

    func enqueueRemoval(of brickId: BrickId) {
        removalQueue.insert(brickId)
    }

    func removeEnqueued() {
        removalQueue.forEach {
            handleBrickRemoval($0)
        }
        removalQueue.removeAll()
    }
    
    func moveBall(to position: CGPoint) {
        nodes.ball.position = position
    }

    func resetBall(sceneSize: CGSize) {
        ballLaunchController.performReset(
            ball: nodes.ball,
            at: CGPoint(x: sceneSize.width / 2, y: 50)
        )
    }

    func update(
        deltaTime dt: TimeInterval,
        sceneSize: CGSize
    ) {
        let newPaddle = paddleMotionController.update(
            paddle: Paddle(
                x: nodes.paddle.position.x,
                w: nodes.paddle.size.width
            ),
            deltaTime: dt,
            sceneSize: sceneSize
        )
        nodes.paddle.position.x = newPaddle.x
        ballLaunchController.update(ball: nodes.ball, paddle: nodes.paddle)
    }

    func beginPaddleKeyboardOverride(to position: CGPoint, sceneSize: CGSize) {
        let newPaddle = paddleMotionController.overridePosition(
            paddle: Paddle(
                x: nodes.paddle.position.x,
                w: nodes.paddle.size.width
            ),
            x: position.x,
            sceneSize: sceneSize
        )
        nodes.paddle.position.x = CGFloat(newPaddle.x)

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

}

// MARK: Handle Brick Removal
extension SKNodeManager {
    private func handleBrickRemoval(_ brickId: BrickId) {
        guard let brickToRemove = findBrick(brickId) else {
            return
        }
        lastBrickHitPosition = brickToRemove.position
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
