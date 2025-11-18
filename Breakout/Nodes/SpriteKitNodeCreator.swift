import Foundation
import SpriteKit
import AppKit

struct SpriteKitNodeCreator: NodeCreator {
    func createNodes(onBrickAdded: @escaping (String, NSColor) -> Void) -> [NodeNames: SKNode] {
        let brickLayout = loadBrickLayout()

        return [
            .paddle: PaddleSprite(position: CGPoint(x: 160, y: 40)),
            .brickLayout: ClassicBricksLayout(bricks: brickLayout, onBrickAdded: onBrickAdded),
            .scoreLabel: ScoreLabel(position: CGPoint(x: 40, y: 460)),
            .livesLabel: LivesLabel(position: CGPoint(x: 280, y: 460)),
            .ball: BallSprite(position: CGPoint(x: 160, y: 50)),
            .topWall: WallSprite(position: CGPoint(x: 160, y: 430), size: CGSize(width: 320, height: 10)),
            .leftWall: WallSprite(position: CGPoint(x: 0, y: 245), size: CGSize(width: 10, height: 470)),
            .rightWall: WallSprite(position: CGPoint(x: 320, y: 245), size: CGSize(width: 10, height: 470)),
            .gutter: GutterSprite(position: CGPoint(x: 160, y: 0), size: CGSize(width: 320, height: 10))
        ]
    }

    private func loadBrickLayout() -> [BrickData] {
        let loader = JsonBrickLayoutLoader()
        do {
            let config = try loader.load(fileName: "001-classic-breakout")
            return try config.generateBricks()
        } catch {
            return []
        }
    }
}
