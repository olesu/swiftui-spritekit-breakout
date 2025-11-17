import SpriteKit

struct BallPhysicsBodyConfigurer {
    let physicsBody: SKPhysicsBody
    
    init(size: CGSize) {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = CollisionCategory.ball.mask
        physicsBody.contactTestBitMask = CollisionCategory.wall.mask
        | CollisionCategory.gutter.mask
        | CollisionCategory.brick.mask
        | CollisionCategory.paddle.mask
        physicsBody.collisionBitMask = CollisionCategory.wall.mask
        | CollisionCategory.brick.mask
        | CollisionCategory.paddle.mask
        physicsBody.restitution = 1.0
        physicsBody.friction = 0
        physicsBody.linearDamping = 0
        physicsBody.angularDamping = 0
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.velocity = CGVector(dx: 200, dy: 300)
    }
}

struct PaddlePhysicsBodyConfigurer {
    let physicsBody: SKPhysicsBody
    
    init(paddleSize: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: paddleSize)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = CollisionCategory.paddle.mask
        physicsBody.contactTestBitMask = CollisionCategory.ball.mask
        physicsBody.collisionBitMask = CollisionCategory.ball.mask
    }
}

struct BrickPhysicsBodyConfigurer {
    let physicsBody: SKPhysicsBody
    
    init(brickSize: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: brickSize)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = CollisionCategory.brick.mask
        physicsBody.contactTestBitMask = CollisionCategory.ball.mask
    }
}

struct GutterPhysicsBodyConfigurer {
    let physicsBody: SKPhysicsBody

    init(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = CollisionCategory.gutter.mask
        physicsBody.contactTestBitMask = CollisionCategory.ball.mask
        physicsBody.collisionBitMask = 0
    }
}

struct WallPhysicsBodyConfigurer {
    let physicsBody: SKPhysicsBody
    
    init(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = CollisionCategory.wall.mask
    }
}
