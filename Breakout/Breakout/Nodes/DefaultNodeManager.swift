import Foundation
import SpriteKit

final class DefaultNodeManager: NodeManager {
    private let ballLaunchController: BallLaunchController
    private let paddleMotionController: PaddleMotionController
    
    let paddle: SKSpriteNode
    let ball: SKSpriteNode = BallSprite(position: CGPoint(x: 160, y: 50))
    
    let bricks: SKNode
    
    var removalQueue: Set<BrickId> = []
    
    let topWall: SKSpriteNode = WallSprite(
        position: CGPoint(x: 160, y: 430),
        size: CGSize(width: 320, height: 10)
    )
    let leftWall: SKSpriteNode = WallSprite(
        position: CGPoint(x: 0, y: 245),
        size: CGSize(width: 10, height: 470)
    )
    let rightWall: SKSpriteNode = WallSprite(
        position: CGPoint(x: 320, y: 245),
        size: CGSize(width: 10, height: 470)
    )
    let gutter: SKSpriteNode = GutterSprite(
        position: CGPoint(x: 160, y: 0),
        size: CGSize(width: 320, height: 10)
    )

    init(
        ballLaunchController: BallLaunchController,
        paddleMotionController: PaddleMotionController,
        brickLayoutFactory: BrickLayoutFactory,
        paddle: PaddleSprite
    ) {
        self.ballLaunchController = ballLaunchController
        self.paddleMotionController = paddleMotionController
        self.bricks = brickLayoutFactory.createBrickLayout()
        self.paddle = paddle
    }

    private func remove(brickId: BrickId) {
        bricks.children.first { $0.name == brickId.value }?.removeFromParent()
    }

    func enqueueRemoval(of brickId: BrickId) {
        removalQueue.insert(brickId)
    }

    func removeEnqueued() {
        removalQueue.forEach { remove(brickId: $0) }
    }

    func moveBall(to position: CGPoint) {
        ball.position = position
    }
    
    func clampBallToPaddle(sceneSize: CGSize) {
        ballLaunchController.performReset(
            ball: ball,
            at: CGPoint(x: sceneSize.width / 2, y: 50)
        )
    }
    
    func updatePaddleAndClampedBall(deltaTime dt: TimeInterval, sceneSize: CGSize) {
        let newPaddle = paddleMotionController.update(
            paddle: Paddle(
                x: paddle.position.x,
                w: paddle.size.width
            ),
            deltaTime: dt,
            sceneSize: sceneSize
        )
        paddle.position.x = newPaddle.x
        ballLaunchController.update(ball: ball, paddle: paddle)
    }
    
    func movePaddle(to position: CGPoint, sceneSize: CGSize) {
        let newPaddle = paddleMotionController.overridePosition(
            paddle: Paddle(
                x: paddle.position.x,
                w: paddle.size.width
            ),
            x: position.x,
            sceneSize: sceneSize
        )
        paddle.position.x = CGFloat(newPaddle.x)

    }
    
    func endPaddleOverride() {
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
    

}
