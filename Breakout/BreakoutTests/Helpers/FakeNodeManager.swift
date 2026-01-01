import Foundation

@testable import Breakout

final class FakeNodeManager: NodeManager {
    var removedBrickIds: [BrickId] = []
    var removalQueue: [BrickId] = []

    var lastBrickHitPosition: CGPoint?

    func removeEnqueued() {
        removalQueue.forEach { removedBrickIds.append($0) }
        removalQueue.removeAll()
    }

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

    func resetBall(sceneSize: CGSize) {

    }

    func update(deltaTime dt: TimeInterval, sceneSize: CGSize) {

    }

}
