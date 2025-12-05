import Testing
import SpriteKit
@testable import Breakout

@Suite("BallResetConfigurator Tests")
struct BallResetConfiguratorTest {

    @Test
    func preparesBallForReset() {
        let ball = SKSpriteNode()
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        ball.physicsBody?.categoryBitMask = CollisionCategory.ball.mask
        ball.alpha = 1

        let configurator = BallResetConfigurator()
        configurator.prepareForReset(ball)

        #expect(ball.physicsBody?.categoryBitMask == 0)
        #expect(ball.physicsBody?.contactTestBitMask == 0)
        #expect(ball.physicsBody?.collisionBitMask == 0)
        #expect(ball.alpha == 0)
    }

    @Test
    func performsBallReset() {
        let ball = SKSpriteNode()
        ball.position = CGPoint(x: 250, y: 10)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        ball.physicsBody?.velocity = CGVector(dx: 100, dy: -50)
        ball.physicsBody?.angularVelocity = 5.0
        ball.alpha = 0

        let configurator = BallResetConfigurator()
        configurator.performReset(ball)

        #expect(ball.position == CGPoint(x: 160, y: 50))
        #expect(ball.physicsBody?.velocity == CGVector.zero)
        #expect(ball.physicsBody?.angularVelocity == 0)
        #expect(ball.alpha == 1)
    }

}
