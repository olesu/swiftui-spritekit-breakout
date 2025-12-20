import Foundation
import SpriteKit

final class DefaultNodeManager: NodeManager {
    private let ballLaunchController: BallLaunchController
    
    let paddle: SKSpriteNode = PaddleSprite(position: CGPoint(x: 160, y: 40))
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
        brickLayoutFactory: BrickLayoutFactory
    ) {
        self.ballLaunchController = ballLaunchController
        self.bricks = brickLayoutFactory.createBrickLayout()
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
    
    func updatePaddleAndClampedBall(x: CGFloat) {
        paddle.position.x = x
        ballLaunchController.update(ball: ball, paddle: paddle)
    }

}
