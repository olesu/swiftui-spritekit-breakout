import Testing
import SpriteKit
@testable import Breakout

struct DefaultNodeManagerTest {

    @Test func removesBrickNodeById() {
        let brickId = BrickId(of: UUID().uuidString)
        let brick = BrickSprite(id: brickId.value, position: CGPoint(x: 100, y: 400), color: .red)

        let brickLayoutFactory = FakeBrickLayoutFactory()
        brickLayoutFactory.addToBrickLayout(brick)
        let manager = DefaultNodeManager(brickLayoutFactory: brickLayoutFactory)
        
        #expect(brick.parent != nil)
        
        manager.enqueueRemoval(of: brickId)
        manager.removeEnqueued()

        #expect(brick.parent == nil)
    }
    
}
