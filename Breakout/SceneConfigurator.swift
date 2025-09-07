import SpriteKit

struct SceneConfigurator {
    static func configurePhysicsWorld(_ scene: SKScene) {
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
}
