import Testing
import SpriteKit

@testable import Breakout

struct SceneNodesTest {

    @Test func attachesAllNodesToParent() async throws {
        let parent = SKNode()
        let nodes = SceneNodes.createValid()

        nodes.attach(to: parent)

        let children = parent.children

        #expect(children.count == 7)
    }

}
