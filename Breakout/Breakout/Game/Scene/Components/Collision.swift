import SpriteKit

struct Collision {
    let categoryA: UInt32
    let nodeA: SKNode?
    let categoryB: UInt32
    let nodeB: SKNode?

    var combinedMask: UInt32 { categoryA | categoryB }

    func node(forCategory category: UInt32) -> SKNode? {
        categoryA == category ? nodeA : nodeB
    }
}
