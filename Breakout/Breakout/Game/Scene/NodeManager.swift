import SpriteKit

protocol NodeManager {
    var paddle: SKSpriteNode { get }
    var ball: SKSpriteNode { get }
    var bricks: SKNode { get }
    
    var topWall: SKSpriteNode { get }
    var leftWall: SKSpriteNode { get }
    var rightWall: SKSpriteNode { get }
    var gutter: SKSpriteNode { get }
    
    func removeEnqueued()
    func enqueueRemoval(of brickId: BrickId)
    
    func moveBall(to position: CGPoint)
    
    func clampBallToPaddle(sceneSize: CGSize)
    func updatePaddleAndClampedBall(deltaTime dt: TimeInterval, sceneSize: CGSize)
    func movePaddle(to position: CGPoint, sceneSize: CGSize)
}
