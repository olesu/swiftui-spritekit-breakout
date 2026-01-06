import Foundation

@testable import Breakout

final class FakeNodeManager: NodeManager {
    var removedBrickIds: [BrickId] = []
    var removalQueue: [BrickId] = []
    
    var removeEnqueuedCount : Int = 0
    var updateCount: Int = 0
    var resetBallCount: Int = 0
    var resetBrickCount: Int = 0

    var lastBrickHitPosition: CGPoint?

    func enqueueRemoval(of brickId: Breakout.BrickId) {
        removalQueue.append(brickId)
    }

    func beginPaddleKeyboardOverride(to position: CGPoint, sceneSize: CGSize) {

    }

    func endPaddleKeyboardOverride() {

    }

    func startPaddleLeft() {

    }

    func startPaddleRight() {

    }

    func stopPaddle() {

    }

    func moveBall(to position: Point) {

    }

    func ballHitPaddle() {

    }

    func resetBall(sceneSize: Size) {
        resetBallCount += 1
    }

    func update(deltaTime dt: TimeInterval, sceneSize: Size, visualGameState: VisualGameState) {
        removalQueue.forEach { removedBrickIds.append($0) }
        removalQueue.removeAll()
        
        removeEnqueuedCount += 1
        updateCount += 1
    }
    
    func resetBricks() {
        resetBrickCount += 1
    }

}
