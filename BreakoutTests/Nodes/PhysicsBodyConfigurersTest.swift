import Testing
import SpriteKit
@testable import Breakout

@Suite("PhysicsBodyConfigurers Tests")
struct PhysicsBodyConfigurersTest {

    @Test("Gutter physics body allows ball to pass through")
    func gutterPhysicsBodyAllowsBallToPassThrough() {
        let configurer = GutterPhysicsBodyConfigurer(size: CGSize(width: 320, height: 10))
        let physicsBody = configurer.physicsBody

        // Gutter should not physically collide with anything
        #expect(physicsBody.collisionBitMask == 0)
    }

    @Test("Gutter physics body detects contact with ball")
    func gutterPhysicsBodyDetectsContactWithBall() {
        let configurer = GutterPhysicsBodyConfigurer(size: CGSize(width: 320, height: 10))
        let physicsBody = configurer.physicsBody

        // Gutter should generate contact events when ball touches it
        #expect(physicsBody.contactTestBitMask == CollisionCategory.ball.mask)
    }
}
