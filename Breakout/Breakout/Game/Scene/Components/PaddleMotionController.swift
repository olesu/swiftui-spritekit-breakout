import SpriteKit

class PaddleMotionController {
    let paddle: SKSpriteNode
    let speed: CGFloat
    let sceneWidth: CGFloat

    init(paddle: SKSpriteNode, speed: CGFloat, sceneWidth: CGFloat) {
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
            paddle.position.x += amount
        }
        if isMovingLeft {
            paddle.position.x -= amount
        }
        
        paddle.position.x = clampedX(paddle.position.x)
    }

    func stop() {
        isMovingLeft = false
        isMovingRight = false
    }
    
    func overridePosition(x: CGFloat) {
        isOverriding = true

        paddle.position.x = clampedX(x)
    }
    
    func endOverride() {
        isOverriding = false
    }
    
    private func clampedX(_ x: CGFloat) -> CGFloat {
        let halfWidth = paddle.size.width / 2
        let minX = halfWidth
        let maxX = sceneWidth - halfWidth
        
        return max(minX, min(maxX, x))
    }
}
