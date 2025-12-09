import SpriteKit

class PaddleMotionController {
    let speed: CGFloat
    let sceneWidth: CGFloat

    private(set) var paddle: Paddle

    init(paddle: Paddle, speed: CGFloat, sceneWidth: CGFloat) {
        self.paddle = paddle
        self.speed = speed
        self.sceneWidth = sceneWidth
    }

    private var isMovingLeft = false
    private var isMovingRight = false

    private var isOverriding = false

    func startLeft() {
        isMovingLeft = true
        isMovingRight = false
    }

    func startRight() {
        isMovingLeft = false
        isMovingRight = true
    }

    func update(deltaTime dt: TimeInterval) {
        guard !isOverriding else { return }
        
        let amount = speed * CGFloat(dt)

        if isMovingRight {
            paddle = paddle.moveBy(amount: +amount)
        }
        if isMovingLeft {
            paddle = paddle.moveBy(amount: -amount)
        }
        
        paddle = paddle.moveTo(clampedX(paddle.x))
    }

    func stop() {
        isMovingLeft = false
        isMovingRight = false
    }
    
    func overridePosition(x: CGFloat) {
        isOverriding = true

        paddle = paddle.moveTo(clampedX(x))
    }
    
    func endOverride() {
        isOverriding = false
    }
    
    private func clampedX(_ x: CGFloat) -> CGFloat {
        let minX = paddle.halfWidth
        let maxX = sceneWidth - paddle.halfWidth
        
        return max(minX, min(maxX, x))
    }
}
