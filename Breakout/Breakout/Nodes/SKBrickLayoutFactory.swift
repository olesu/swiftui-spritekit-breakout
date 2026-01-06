import Foundation

struct SKBrickLayoutFactory: BrickLayoutFactory {
    private let bricksProvider: BricksProvider

    init(bricksProvider: BricksProvider) {
        self.bricksProvider = bricksProvider
    }

    func createNodes() -> SpriteContainer {
        let brickData = bricksProvider.bricks.map {
            BrickData(id: $1.id.value, position: $1.position, color: $1.color)
        }

        return SKBricksLayout(brickData: brickData)
    }
}
