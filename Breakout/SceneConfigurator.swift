import SpriteKit

struct SceneConfigurator {
    private static func configurePhysicsWorld(_ scene: SKScene, delegate: SKPhysicsContactDelegate? = nil) {
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        scene.physicsWorld.contactDelegate = delegate
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
    
    static func configureScene(_ scene: SKScene, bounds: CGRect, view: SKView? = nil, delegate: SKPhysicsContactDelegate? = nil) {
        configureBackground(scene)
        configurePhysicsWorld(scene, delegate: delegate)
        configurePhysicsBody(scene, bounds: bounds)
        configureMouse(view)
    }
}
