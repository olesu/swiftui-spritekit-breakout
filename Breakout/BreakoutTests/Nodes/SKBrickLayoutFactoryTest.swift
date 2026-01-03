import SpriteKit
import Testing

@testable import Breakout

struct SKBrickLayoutFactoryTest {
    @Test func createsLayoutFromSpec() {
        let bricksProvider = FakeBricksProvider()
        bricksProvider.addBrick(Brick.createValid())

        let creator = SKBrickLayoutFactory(
            bricksProvider: bricksProvider
        )

        let layout = creator.createNodes()

        #expect(layout.children.count == 1)
    }
}

private final class FakeBricksProvider: BricksProvider {
    var bricks: [BrickId : Brick] = [:]

    func addBrick(_ brick: Brick) {
        bricks[brick.id] = brick
    }
}
