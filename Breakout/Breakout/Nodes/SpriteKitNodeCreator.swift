import AppKit
import Foundation
import SpriteKit

struct SpriteKitNodeCreator: NodeCreator {
    private let session: GameSession
    
    init(session: GameSession) {
        self.session = session
    }

    func createNodes() -> [NodeNames: SKNode] {
        let bricks = session.state.bricks
        let brickSpecs = bricks.map { BrickSpec.init(brick: $1) }

        return [
            .paddle: PaddleSprite(position: CGPoint(x: 160, y: 40)),
            .brickLayout: ClassicBricksLayout(brickSpecs: brickSpecs),
            .ball: BallSprite(position: CGPoint(x: 160, y: 50)),
            .topWall: WallSprite(
                position: CGPoint(x: 160, y: 430),
                size: CGSize(width: 320, height: 10)
            ),
            .leftWall: WallSprite(
                position: CGPoint(x: 0, y: 245),
                size: CGSize(width: 10, height: 470)
            ),
            .rightWall: WallSprite(
                position: CGPoint(x: 320, y: 245),
                size: CGSize(width: 10, height: 470)
            ),
            .gutter: GutterSprite(
                position: CGPoint(x: 160, y: 0),
                size: CGSize(width: 320, height: 10)
            ),
        ]
    }
}
