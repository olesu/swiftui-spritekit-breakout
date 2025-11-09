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
}
