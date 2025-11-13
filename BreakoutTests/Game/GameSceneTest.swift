import Testing
import SpriteKit
@testable import Breakout

struct GameSceneTest {

    /*
     TDD Task List for GameScene Collision Handling:

     Event Callback:
     [x] Accepts onGameEvent closure in initializer
     [x] Calls closure when ball hits brick (implemented in didBegin)
     [x] Calls closure when ball hits gutter (implemented in didBegin)
     [x] Extracts correct brick ID from collision (UUID conversion)

     Physics Setup:
     [x] Sets physics contact delegate
     [x] Configures physics world (done via didMove)

     Brick Removal:
     [x] Removes brick node from scene when hit
     [x] Can find brick by UUID

     Ball Reset:
     [x] Resets ball position to starting point
     [x] Resets ball velocity to initial values
     [ ] Resets ball automatically when lives remain after ball lost
     [ ] Does NOT reset ball when game over (lives = 0)
     */

    @Test func acceptsGameEventCallback() async throws {
        var capturedEvents: [GameEvent] = []
        let onGameEvent: (GameEvent) -> Void = { event in
            capturedEvents.append(event)
        }

        let scene = GameScene(
            size: CGSize(width: 320, height: 480),
            brickArea: CGRect(x: 20, y: 330, width: 280, height: 120),
            nodes: [:],
            onGameEvent: onGameEvent
        )

        #expect(scene != nil)
    }

    @Test func setsPhysicsContactDelegate() async throws {
        let scene = GameScene(
            size: CGSize(width: 320, height: 480),
            brickArea: CGRect(x: 20, y: 330, width: 280, height: 120),
            nodes: [:],
            onGameEvent: { _ in }
        )

        let view = SKView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        view.presentScene(scene)

        #expect(scene.physicsWorld.contactDelegate != nil)
    }

    @Test func removesBrickWhenHit() async throws {
        let brickId = UUID()
        let brick = BrickSprite(id: brickId, position: CGPoint(x: 100, y: 400), color: .red)
        let brickLayout = SKNode()
        brickLayout.addChild(brick)

        let scene = GameScene(
            size: CGSize(width: 320, height: 480),
            brickArea: CGRect(x: 20, y: 330, width: 280, height: 120),
            nodes: [.brickLayout: brickLayout],
            onGameEvent: { _ in }
        )

        let view = SKView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        view.presentScene(scene)

        #expect(brick.parent != nil)

        scene.removeBrick(id: brickId)

        #expect(brick.parent == nil)
    }

    @Test func resetsBallPositionAndVelocity() async throws {
        let ball = BallSprite(position: CGPoint(x: 160, y: 50))

        let scene = GameScene(
            size: CGSize(width: 320, height: 480),
            brickArea: CGRect(x: 20, y: 330, width: 280, height: 120),
            nodes: [.ball: ball],
            onGameEvent: { _ in }
        )

        let view = SKView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        view.presentScene(scene)

        // Move ball to a different position and change velocity
        ball.position = CGPoint(x: 50, y: 200)
        ball.physicsBody?.velocity = CGVector(dx: 50, dy: 50)

        // Reset the ball
        scene.resetBall()

        // Verify position is reset to starting point
        #expect(ball.position.x == 160)
        #expect(ball.position.y == 50)

        // Verify velocity is reset to initial values
        #expect(ball.physicsBody?.velocity.dx == 200)
        #expect(ball.physicsBody?.velocity.dy == 300)
    }
}
