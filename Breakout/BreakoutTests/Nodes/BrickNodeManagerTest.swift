import Testing
import SpriteKit
@testable import Breakout

struct BrickNodeManagerTest {

    @Test func removesBrickNodeById() {
        let brickId = BrickId(of: UUID().uuidString)
        let brick = BrickSprite(id: brickId.value, position: CGPoint(x: 100, y: 400), color: .red)
        let brickLayout = SKNode()
        brickLayout.addChild(brick)

        let manager = BrickNodeManager(brickLayout: brickLayout)

        #expect(brick.parent != nil)

        manager.remove(brickId: brickId)

        #expect(brick.parent == nil)
    }
}
