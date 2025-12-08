struct CollisionMaskMatcher {
    let ball: UInt32
    let brick: UInt32
    let gutter: UInt32
    let paddle: UInt32
    
    init() {
        ball = CollisionCategory.ball.mask
        brick = CollisionCategory.brick.mask
        gutter = CollisionCategory.gutter.mask
        paddle = CollisionCategory.paddle.mask
    }
    
    func isBallBrick(_ combined: UInt32) -> Bool {
        combined == (ball | brick)
    }
    
    func isBallGutter(_ combined: UInt32) -> Bool {
        combined == (ball | gutter)
    }
    
    func isBallPaddle(_ combined: UInt32) -> Bool {
        combined == (ball | paddle)
    }
}
