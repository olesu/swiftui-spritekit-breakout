import SpriteKit

struct BallResetConfigurator {
    private let resetPosition: CGPoint
    private let resetVelocity: CGVector

    init(resetPosition: CGPoint = CGPoint(x: 160, y: 50),
         resetVelocity: CGVector = CGVector(dx: 200, dy: 300)) {
        self.resetPosition = resetPosition
        self.resetVelocity = resetVelocity
    }

    func prepareForReset(_ ball: SKNode) {
        ball.physicsBody?.categoryBitMask = 0
        ball.physicsBody?.contactTestBitMask = 0
        ball.physicsBody?.collisionBitMask = 0
        ball.alpha = 0
    }

    func performReset(_ ball: SKNode) {
        ball.physicsBody?.velocity = .zero
        ball.physicsBody?.angularVelocity = 0

        ball.position = resetPosition

        ball.physicsBody?.categoryBitMask = CollisionCategory.ball.mask
        ball.physicsBody?.contactTestBitMask = CollisionCategory.wall.mask
            | CollisionCategory.gutter.mask
            | CollisionCategory.brick.mask
            | CollisionCategory.paddle.mask
        ball.physicsBody?.collisionBitMask = CollisionCategory.wall.mask
            | CollisionCategory.brick.mask
            | CollisionCategory.paddle.mask

        ball.alpha = 1
        ball.physicsBody?.velocity = resetVelocity
    }
}
