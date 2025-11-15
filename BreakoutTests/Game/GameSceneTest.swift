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

     */

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
}
