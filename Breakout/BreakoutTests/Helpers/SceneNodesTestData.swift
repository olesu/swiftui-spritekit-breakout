import SpriteKit
import Foundation

@testable import Breakout

extension SceneNodes {
    static func createValid(
        paddle: PaddleSprite = PaddleSprite(position: .zero, size: .zero),
        ball: BallSprite = BallSprite(position: .zero),
        bricks: SKNode = SKNode(),
        topWall: WallSprite = WallSprite(position: .zero, size: .zero),
        leftWall: WallSprite = WallSprite(position: .zero, size: .zero),
        rightWall: WallSprite = WallSprite(position: .zero, size: .zero),
        gutter: GutterSprite = GutterSprite(position: .zero, size: .zero)
    ) -> Self {
        .init(
            paddle: paddle,
            ball: ball,
            bricks: bricks,
            topWall: topWall,
            leftWall: leftWall,
            rightWall: rightWall,
            gutter: gutter,
        )
    }
}

