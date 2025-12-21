import SpriteKit

protocol NodeManager {
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
    func resetBall(sceneSize: CGSize)
    func update(deltaTime dt: TimeInterval, sceneSize: CGSize)
}
