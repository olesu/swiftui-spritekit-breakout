import SpriteKit

protocol NodeManager {
    // TODO: Does it make sense to separate command and query now? (I.e., NodeCommands, NodeQueries)?
    // MARK: Queries
    var lastBrickHitPosition: CGPoint? { get }

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
    func moveBall(to position: Point)
    func ballHitPaddle()
    
    // MARK: ball and paddle
    func resetBall(sceneSize: CGSize)
    func update(deltaTime dt: TimeInterval, sceneSize: CGSize)
}
