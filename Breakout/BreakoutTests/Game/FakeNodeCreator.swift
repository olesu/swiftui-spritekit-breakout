import SpriteKit

@testable import Breakout

struct FakeNodeCreator: NodeCreator {
    func createNodes() -> [Breakout.NodeNames : SKNode] {
        return [:]
    }
}
