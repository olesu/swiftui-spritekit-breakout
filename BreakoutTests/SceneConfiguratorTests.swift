import Testing
import SpriteKit
@testable import Breakout

struct SceneConfiguratorTests {
    let scene = SKScene(size: CGSize(width: 400, height: 600))
    
    @Test func configuresPhysicsWorldWithZeroGravity() {
        SceneConfigurator.configurePhysicsWorld(scene)
        
        #expect(scene.physicsWorld.gravity == CGVector(dx: 0, dy: 0))
    }

    @Test func configuresPhysicsBody() {
        SceneConfigurator.configurePhysicsBody(scene, bounds: CGRect(origin: .zero, size: scene.size))
        
        guard let physicsBody = scene.physicsBody else {
            Issue.record("Scene must have a physics body")
            return
        }
        
        #expect(physicsBody.categoryBitMask == PhysicsCategory.wall)
        #expect(physicsBody.contactTestBitMask == PhysicsCategory.ball)
        #expect(physicsBody.collisionBitMask == PhysicsCategory.ball)
    }
    
}
