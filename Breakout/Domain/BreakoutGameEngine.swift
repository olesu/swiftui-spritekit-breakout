import Foundation

class BreakoutGameEngine {
    private var bricks: Bricks
    private var scoreCard: ScoreCard

    var remainingBrickCount: Int {
        bricks.someRemaining ? 1 : 0
    }

    var currentScore: Int {
        scoreCard.total
    }

    init(bricks: Bricks) {
        self.bricks = bricks
        self.scoreCard = ScoreCard()
    }

    func process(event: GameEvent) {
        switch event {
        case .brickHit(let brickID):
            bricks.remove(withId: BrickId(of: brickID.uuidString))
            scoreCard.score(1)
        case .ballLost:
            break
        }
    }
}
