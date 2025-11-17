import Testing
import SpriteKit
@testable import Breakout

struct BrickNodeManagerTest {

    @Test @MainActor func removesBrickNodeById() async throws {
        let brickId = UUID()
        let brick = BrickSprite(id: brickId, position: CGPoint(x: 100, y: 400), color: .red)
        let brickLayout = SKNode()
        brickLayout.addChild(brick)

        let manager = BrickNodeManager(brickLayout: brickLayout)

        #expect(brick.parent != nil)

        manager.remove(brickId: brickId)

        #expect(brick.parent == nil)
    }
}
