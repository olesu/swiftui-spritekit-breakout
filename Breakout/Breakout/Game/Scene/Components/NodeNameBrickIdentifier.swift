import SpriteKit

struct NodeNameBrickIdentifier: BrickNodeIdentifying {
    func brickId(from node: SKNode?) -> BrickId? {
        guard let name = node?.name else { return nil }

        return BrickId(of: name)
    }

}
