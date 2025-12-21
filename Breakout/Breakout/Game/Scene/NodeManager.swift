import SpriteKit

protocol NodeManager {
    var topWall: SKSpriteNode { get }
    var leftWall: SKSpriteNode { get }
    var rightWall: SKSpriteNode { get }
    var gutter: SKSpriteNode { get }
    
    // MARK: bricks
    func removeEnqueued()
    func enqueueRemoval(of brickId: BrickId)

    // MARK: paddle
    func beginPaddleKeyboardOverride(to position: CGPoint, sceneSize: CGSize)
    func endPaddleKeyboardOverride()
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
