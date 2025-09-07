import SpriteKit

struct SceneConfigurator {
    private static func configurePhysicsWorld(_ scene: SKScene) {
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    private static func configureBackground(_ scene: SKScene) {
        scene.backgroundColor = .black
    }
    
    private static func configurePhysicsBody(_ scene: SKScene, bounds: CGRect) {
        let physicsBody = SKPhysicsBody(edgeLoopFrom: bounds)
        
        physicsBody.categoryBitMask = PhysicsCategory.wall
        physicsBody.contactTestBitMask = PhysicsCategory.ball
        physicsBody.collisionBitMask = PhysicsCategory.ball

        scene.physicsBody = physicsBody
    }
    
    private static func configureMouse(_ view: SKView? = nil) {
        view?.window?.acceptsMouseMovedEvents = true
    }
    
    static func configureScene(_ scene: SKScene, bounds: CGRect, view: SKView? = nil) {
        configureBackground(scene)
        configurePhysicsWorld(scene)
        configurePhysicsBody(scene, bounds: bounds)
        configureMouse(view)
    }
}
