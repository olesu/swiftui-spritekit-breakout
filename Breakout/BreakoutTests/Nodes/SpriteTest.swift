import Testing
import SpriteKit

@testable import Breakout

struct SpriteTest {

    @Test func attachAddsUnderlyingNodeToParent() {
        let parent = SKNode()
        let sprite = TestSprite()

        sprite.attach(to: parent)

        #expect(parent.children.contains(sprite.node))
    }

}

private final class TestSprite: Sprite {
    var node: SKSpriteNode = SKSpriteNode()
}
