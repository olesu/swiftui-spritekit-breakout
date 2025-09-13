import Foundation
import SpriteKit

class BrickController: SKSpriteNode {
    init(model brick: Brick) {
        super.init(texture: nil, color: .red, size: GameConstants.brickSize)
        position = CGPoint(
            x: CGFloat.random(in: GameConstants.brickXRange),
            y: CGFloat.random(in: GameConstants.brickYRange),
        )
        name = brick.id.uuidString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
