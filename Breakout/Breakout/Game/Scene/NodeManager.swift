import SpriteKit

protocol NodeManager {
    var paddle: SKSpriteNode { get }
    var ball: SKSpriteNode { get }
    var bricks: SKNode { get }
    
    var topWall: SKSpriteNode { get }
    var leftWall: SKSpriteNode { get }
    var rightWall: SKSpriteNode { get }
    var gutter: SKSpriteNode { get }
    
    // MARK: bricks
    func removeEnqueued()
    func enqueueRemoval(of brickId: BrickId)

    // MARK: paddle
    func movePaddle(to position: CGPoint, sceneSize: CGSize)
    func endPaddleOverride()
    func startPaddleLeft()
    func startPaddleRight()
    func stopPaddle()
    
    // MARK: ball
    func moveBall(to position: CGPoint)
    func ballHitPaddle()
    
    // MARK: ball and paddle
    func clampBallToPaddle(sceneSize: CGSize)
    func updatePaddleAndClampedBall(deltaTime dt: TimeInterval, sceneSize: CGSize)
}
