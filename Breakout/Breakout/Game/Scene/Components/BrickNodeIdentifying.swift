import SpriteKit

protocol BrickNodeIdentifying {
    func brickId(from node: SKNode?) -> BrickId? // TODO: Why use optionals?
}
