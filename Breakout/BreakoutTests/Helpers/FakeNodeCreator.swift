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
    
    func hasParent(_ brickId: BrickId) -> Bool {
        brickLayout.childNode(withName: brickId.value) != nil
    }
    
    func position(of brickId: BrickId) -> CGPoint {
        guard let node = brickLayout.childNode(withName: brickId.value) else {
            return CGPoint(x: Int.max, y: Int.max)
        }
        
        return node.position
    }
}
