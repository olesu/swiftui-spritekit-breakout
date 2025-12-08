import SpriteKit
import Testing

@testable import Breakout

@MainActor
struct DefaultCollisionRouterTests {
    private let collisionRouter = DefaultCollisionRouter(
        brickIdentifier: NodeNameBrickIdentifier()
    )

    @Test func routesBallBrickCollision() {
        let ballMask = CollisionCategory.ball.mask
        let brickMask = CollisionCategory.brick.mask

        let brickNode = SKNode()
        brickNode.name = "brick-42"

        let result = collisionRouter.route(
            Collision(
                categoryA: ballMask,
                nodeA: SKNode(),
                categoryB: brickMask,
                nodeB: brickNode
            )
        )

        #expect(result == .ballHitBrick(BrickId: BrickId(of: "brick-42")))
    }

    @Test func routesBallGutterCollision() {
        let result = collisionRouter.route(
            Collision(
                categoryA: CollisionCategory.ball.mask,
                nodeA: SKNode(),
                categoryB: CollisionCategory.gutter.mask,
                nodeB: SKNode()
            )
        )

        #expect(result == .ballHitGutter)
    }

    @Test func routesBallPaddleCollision() {
        let result = collisionRouter.route(
            Collision(
                categoryA: CollisionCategory.ball.mask,
                nodeA: SKNode(),
                categoryB: CollisionCategory.paddle.mask,
                nodeB: SKNode()
            )
        )

        #expect(result == .ballHitPaddle)
    }

    @Test func returnsNoneWhenBrickNodeHasNoName() {
        let result = collisionRouter.route(
            Collision(
                categoryA: CollisionCategory.ball.mask,
                nodeA: SKNode(),
                categoryB: CollisionCategory.brick.mask,
                nodeB: SKNode()
            )
        )

        #expect(result == .none)
    }

}
