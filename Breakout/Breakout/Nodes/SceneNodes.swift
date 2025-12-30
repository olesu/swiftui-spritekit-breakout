import SpriteKit
import Foundation

/// Owns all Sprites in the scene.
/// Nodes are mutated by NodeManager, not replaced.
struct SceneNodes {
    let paddle: Sprite
    let ball: Sprite
    let bricks: SpriteContainer
    let topWall: Attachable
    let leftWall: Attachable
    let rightWall: Attachable
    let gutter: Attachable
}

extension SceneNodes: Attachable {
    func attach(to parent: SKNode) {
        topWall.attach(to: parent)
        leftWall.attach(to: parent)
        rightWall.attach(to: parent)
        gutter.attach(to: parent)

        bricks.attach(to: parent)

        paddle.attach(to: parent)
        ball.attach(to: parent)


    }
    
    
}
