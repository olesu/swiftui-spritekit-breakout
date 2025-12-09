import SpriteKit

protocol NodeManager {
    var allNodes: [SKNode] { get }
    func remove(brickId: BrickId)
}
