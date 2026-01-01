import AppKit
import Foundation
import SpriteKit

struct SKBrickLayoutFactory: BrickLayoutFactory {
    private let session: GameSession

    init(session: GameSession) {
        self.session = session
    }

    func createNodes() -> SpriteContainer {
        let bricks = session.state.bricks
        let brickData = bricks.map {
            BrickData(id: $1.id.value, position: $1.position, color: $1.color)
        }

        return SKBricksLayout(brickData: brickData)
    }
}
