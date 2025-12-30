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
        let brickSpecs = bricks.map { BrickSpec.init(brick: $1) }

        return SKBricksLayout(brickSpecs: brickSpecs)
    }
}
