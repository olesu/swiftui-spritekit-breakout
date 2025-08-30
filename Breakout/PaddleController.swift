import Foundation
import SpriteKit

class PaddleController: SKSpriteNode {
    private var paddle: Paddle
    
    init(gameAreaWidth: CGFloat) {
        // Initialize the paddle model with the game area constraints
        self.paddle = Paddle(
            position: CGPoint(x: gameAreaWidth / 2, y: 50),
            size: CGSize(width: 80, height: 16),
            minX: 40, // half paddle width
            maxX: gameAreaWidth - 40 // game width - half paddle width
        )
        
        super.init(
            texture: nil,
            color: .white,
            size: paddle.size
        )
        
        self.position = paddle.position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveTo(x: CGFloat) {
        paddle.move(to: x)
        self.position = paddle.position
    }
    
    var paddleFrame: CGRect {
        return CGRect(
            x: position.x - size.width / 2,
            y: position.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }
}
