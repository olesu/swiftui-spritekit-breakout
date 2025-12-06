import SpriteKit

@testable import Breakout

struct FakeNodeCreator: NodeCreator {
    func createNodes(onBrickAdded: @escaping (Breakout.Brick) -> Void) -> [Breakout.NodeNames : SKNode] {
        return [:]
    }
}
