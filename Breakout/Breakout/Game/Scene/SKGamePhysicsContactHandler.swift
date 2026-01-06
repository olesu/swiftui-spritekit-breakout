import SpriteKit

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

    func didEnd(_ contact: SKPhysicsContact) {
    }

}
