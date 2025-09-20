import Foundation
import SpriteKit

func initNodes() -> [NodeNames: SKNode] {
    [
        .paddle: PaddleSprite(position: CGPoint(x: 160, y: 40)),
        .brickLayout: ClassicBricksLayout(),
        .scoreLabel: ScoreLabel(position: CGPoint(x: 40, y: 460)),
        .livesLabel: LivesLabel(position: CGPoint(x: 280, y: 460)),
        .ball: BallSprite(position: CGPoint(x: 160, y: 50)),
        .topWall: WallNode(position: CGPoint(x: 160, y: 430), size: CGSize(width: 320, height: 10)),
        .leftWall: WallNode(position: CGPoint(x: 0, y: 240), size: CGSize(width: 10, height: 480)),
        .rightWall: WallNode(position: CGPoint(x: 320, y: 240), size: CGSize(width: 10, height: 480)),
        .gutter: GutterSprite(position: CGPoint(x: 160, y: 0), size: CGSize(width: 320, height: 10))
    ]
}

