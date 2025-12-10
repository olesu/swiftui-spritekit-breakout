import AppKit
import Foundation
import SpriteKit

struct ClassicBrickLayoutFactory: BrickLayoutFactory {
    private let session: GameSession
    
    init(session: GameSession) {
        self.session = session
    }

    func createBrickLayout() -> SKNode {
        let bricks = session.state.bricks
        let brickSpecs = bricks.map { BrickSpec.init(brick: $1) }

        return ClassicBricksLayout(brickSpecs: brickSpecs)
    }
}
