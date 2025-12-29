import SpriteKit

/// Handles SpriteKit physics contacts and translates them into high-level game events.
///
/// This handler:
/// - Uses `CollisionRouter` to classify contacts.
/// - Applies state changes to `GameSession`.
/// - Removes bricks via `NodeManager`.
/// - Adjusts ball speed and bounce on paddle hits using `BallMotionController` and `PaddleBounceApplier`.
final class SKGamePhysicsContactHandler: NSObject, SKPhysicsContactDelegate {
    private let collisionRouter: CollisionRouter
    private let nodeManager: NodeManager
    private let gameEventHandler: GameEventHandler

    init(
        collisionRouter: CollisionRouter,
        nodeManager: NodeManager,
        gameEventHandler: GameEventHandler
    ) {
        self.collisionRouter = collisionRouter
        self.nodeManager = nodeManager
        self.gameEventHandler = gameEventHandler
    }

    /// Handles the start of a physics contact and translates it into a game event.
    ///
    /// SpriteKit calls this when two physics bodies begin contacting. The method delegates
    /// classification to `collisionRouter`, which converts raw category masks and nodes into a
    /// high-level collision result. Based on that result, this handler:
    /// - Removes a hit brick and updates `GameSession`.
    /// - Marks the ball as lost when it enters the gutter.
    /// - Adjusts ball speed and bounce when it hits the paddle.
    ///
    /// - Parameter contact: The contact information provided by SpriteKit.
    func didBegin(_ contact: SKPhysicsContact) {
        let result = collisionRouter.route(
            Collision(
                categoryA: contact.bodyA.categoryBitMask,
                nodeA: contact.bodyA.node,
                categoryB: contact.bodyB.categoryBitMask,
                nodeB: contact.bodyB.node
            )
        )

        switch result {
        case .ballHitBrick(let brickId):
            gameEventHandler.handle(.brickHit(brickID: brickId))
        case .ballHitGutter:
            gameEventHandler.handle(.ballLost)
        case .ballHitPaddle:
            nodeManager.ballHitPaddle()
        case .none:
            break
        }
    }

    /// Called when two bodies stop contacting. Currently unused.
    func didEnd(_ contact: SKPhysicsContact) {
        // No-op, but available for future use (e.g., clearing transient state).
    }

}
