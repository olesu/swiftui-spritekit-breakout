import SpriteKit

@testable import Breakout

struct FakeBrickLayoutFactory: BrickLayoutFactory {
    let brickLayout = SKNode()
    
    func createNodes() -> SKNode {
        return brickLayout
    }
    
    func addToBrickLayout(_ node: SKNode) {
        brickLayout.addChild(node)
    }
}
