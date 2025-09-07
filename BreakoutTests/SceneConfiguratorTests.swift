import Testing
import SpriteKit
@testable import Breakout

struct SceneConfiguratorTests {
    @Test func configuresPhysicsWorldWithZeroGravity() {
        let scene = SKScene(size: CGSize(width: 400, height: 600))
        
        SceneConfigurator.configurePhysicsWorld(scene)
        
        #expect(scene.physicsWorld.gravity == CGVector(dx: 0, dy: 0))
    }
    
}
