import SpriteKit
import Foundation

/// Owns all Sprites in the scene.
/// Nodes are mutated by NodeManager, not replaced.
struct SceneNodes {
    let paddle: SKSpriteNode
    let ball: SKSpriteNode
    let bricks: SKNode
    let topWall: Sprite
    let leftWall: Sprite
    let rightWall: Sprite
    let gutter: Sprite
}
