import AppKit
import Foundation
import SpriteKit
import os.log

internal struct SpriteKitNodeCreator: NodeCreator {
    private let brickSpecs: [(BrickData, BrickColor)]
    
    internal init(
        brickSpecs: [(BrickData, BrickColor)]
    ) {
        self.brickSpecs = brickSpecs
    }

    internal func createNodes(
        onBrickAdded: @escaping (Brick) -> Void
    ) -> [NodeNames: SKNode] {
        let layout = ClassicBricksLayout(brickSpecs: brickSpecs)

        layout.createdBricks.forEach(onBrickAdded)

        return [
            .paddle: PaddleSprite(position: CGPoint(x: 160, y: 40)),
            .brickLayout: layout,
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
