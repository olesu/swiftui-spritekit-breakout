import SpriteKit

class PaddleMotionController {
    let speed: CGFloat

    init(speed: CGFloat) {
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

    func update(paddle: Paddle, deltaTime dt: TimeInterval, sceneSize: CGSize) -> Paddle {
        let amount = speed * CGFloat(dt)
        var dx: CGFloat = 0

        if !isOverriding {
            if isMovingRight { dx += amount }
            if isMovingLeft { dx -= amount }
        }

        let newX = paddle.x + dx
        return paddle.moveTo(clampedX(paddle, x: newX, sceneWidth: sceneSize.width))
    }

    func stop() {
        isMovingLeft = false
        isMovingRight = false
    }
    
    func overridePosition(paddle: Paddle, x: CGFloat, sceneSize: CGSize) -> Paddle {
        isOverriding = true
        let clamped = clampedX(paddle, x: x, sceneWidth: sceneSize.width)
        return paddle.moveTo(clamped)
    }
    
    func endOverride() {
        isOverriding = false
    }
    
    private func clampedX(_ paddle: Paddle, x: CGFloat, sceneWidth: CGFloat) -> CGFloat {
        let minX = paddle.halfWidth
        let maxX = sceneWidth - paddle.halfWidth
        return max(minX, min(maxX, x))
    }
}

