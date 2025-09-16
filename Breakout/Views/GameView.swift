import Foundation
import SwiftUI
import SpriteKit

class BreakoutScene: SKScene, SKPhysicsContactDelegate {
    let gameSize = CGSize(width: 320, height: 480)
    let sprites: [NodeNames: SKNode] = initNodes()
    let autoPaddle: AutoPaddle
    
    override init() {
        self.autoPaddle = AutoPaddle(
            paddle: sprites[.paddle] as! PaddleSprite,
            ball: sprites[.ball] as! BallSprite
        )
        super.init(size: CGSize(width: 320, height: 480))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        view.showsPhysics = true
        view.showsFPS = true
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        sprites.values.forEach { addChild($0) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        autoPaddle.move()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if let _ = nodeA as? BallSprite, let brick = nodeB as? BrickSprite {
            print("brick hit at (\(brick.position.x), \(brick.position.y))")
            brick.removeFromParent()
        } else if let _ = nodeB as? BallSprite, let brick = nodeA as? BrickSprite {
            print("brick hit at (\(brick.position.x), \(brick.position.y))")
            brick.removeFromParent()
        }
    }
}

struct GameView: View {
    var breakoutScene: SKScene {
        let scene = BreakoutScene()
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .black
        return scene
    }
    
    var body: some View {
        SpriteView(scene: breakoutScene)
            .frame(width: 320, height: 480)
    }
}

#Preview {
    GameView()
}
