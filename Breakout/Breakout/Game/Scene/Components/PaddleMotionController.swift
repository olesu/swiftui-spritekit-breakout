import SpriteKit

class PaddleMotionController {
    let speed: CGFloat

    private(set) var paddle: Paddle

    init(paddle: Paddle, speed: CGFloat) {
        self.paddle = paddle
        self.speed = speed
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

    func update(deltaTime dt: TimeInterval, sceneSize: CGSize) {
        let amount = speed * CGFloat(dt)
        var dx: CGFloat = 0

        if !isOverriding {
            if isMovingRight { dx += amount }
            if isMovingLeft { dx -= amount }
        }

        let newX = paddle.x + dx
        paddle = paddle.moveTo(clampedX(newX, sceneWidth: sceneSize.width))
    }

    func stop() {
        isMovingLeft = false
        isMovingRight = false
    }
    
    func overridePosition(x: CGFloat, sceneSize: CGSize) {
        isOverriding = true
        let clamped = clampedX(x, sceneWidth: sceneSize.width)
        paddle = paddle.moveTo(clamped)
    }
    
    func endOverride() {
        isOverriding = false
    }
    
    private func clampedX(_ x: CGFloat, sceneWidth: CGFloat) -> CGFloat {
        let minX = paddle.halfWidth
        let maxX = sceneWidth - paddle.halfWidth
        return max(minX, min(maxX, x))
    }
}

