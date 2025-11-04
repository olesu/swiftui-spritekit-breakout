import Foundation

class BreakoutGameEngine {
    private var bricks: Bricks

    var remainingBrickCount: Int {
        bricks.someRemaining ? 1 : 0
    }

    init(bricks: Bricks) {
        self.bricks = bricks
    }

    func process(event: GameEvent) {
        switch event {
        case .brickHit(let brickID):
            bricks.remove(withId: BrickId(of: brickID.uuidString))
        case .ballLost:
            break
        }
    }
}
