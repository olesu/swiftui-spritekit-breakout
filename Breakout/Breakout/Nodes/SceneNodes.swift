import SpriteKit
import Foundation

/// Owns all SpriteKit nodes in the scene.
/// Nodes are mutated by NodeManager, not replaced.
struct SceneNodes {
    let paddle: SKSpriteNode
    let ball: SKSpriteNode
    let bricks: SKNode
    let topWall: SKSpriteNode
    let leftWall: SKSpriteNode
    let rightWall: SKSpriteNode
    let gutter: SKSpriteNode
}
