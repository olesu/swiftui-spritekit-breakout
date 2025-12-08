import SpriteKit

struct DefaultCollisionRouter: CollisionRouter {
    private let brickIdentifier: BrickNodeIdentifying
    private let matcher = CollisionMaskMatcher()
    
    init(brickIdentifier: BrickNodeIdentifying) {
        self.brickIdentifier = brickIdentifier
    }
    
    func route(_ c: Collision) -> RoutedCollision {
        let combined = c.combinedMask
        
        if matcher.isBallBrick(combined) {
            let brickNode = c.node(forCategory: matcher.brick)
            if let id = brickIdentifier.brickId(from: brickNode) {
                return .ballHitBrick(BrickId: id)
            } else {
                return .none
            }
        }
        
        if matcher.isBallGutter(combined) {
            return .ballHitGutter
        }
        
        if matcher.isBallPaddle(combined) {
            return .ballHitPaddle
        }
        
        return .none
    }
}
