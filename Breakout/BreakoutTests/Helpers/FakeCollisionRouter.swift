@testable import Breakout

final class FakeCollisionRouter: CollisionRouter {
    private var routedCollisions: [UInt32: RoutedCollision] = [:]
    func route(_ collision: Collision) -> RoutedCollision {
        routedCollisions[collision.combinedMask] ?? .none
    }
}
