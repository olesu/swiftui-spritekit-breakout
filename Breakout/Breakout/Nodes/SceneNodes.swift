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
