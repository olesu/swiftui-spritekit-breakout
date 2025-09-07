import SpriteKit

struct SceneConfigurator {
    static func configurePhysicsWorld(_ scene: SKScene) {
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    static func configureBackground(_ scene: SKScene) {
        scene.backgroundColor = .black
    }
    
    static func configurePhysicsBody(_ scene: SKScene, bounds: CGRect) {
        let physicsBody = SKPhysicsBody(edgeLoopFrom: bounds)
        
        physicsBody.categoryBitMask = PhysicsCategory.wall
        physicsBody.contactTestBitMask = PhysicsCategory.ball
        physicsBody.collisionBitMask = PhysicsCategory.ball

        scene.physicsBody = physicsBody
    }
    
    static func configureMouse(_ view: SKView) {
        view.window?.acceptsMouseMovedEvents = true
    }
}
