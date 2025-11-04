import Foundation

class BreakoutGameEngine {
    private var bricks: Bricks
    private var scoreCard: ScoreCard
    private var livesCard: LivesCard

    var remainingBrickCount: Int {
        bricks.someRemaining ? 1 : 0
    }

    var currentScore: Int {
        scoreCard.total
    }

    var remainingLives: Int {
        livesCard.remaining
    }

    init(bricks: Bricks, lives: Int = 3) {
        self.bricks = bricks
        self.scoreCard = ScoreCard()
        self.livesCard = LivesCard(lives)
    }

    func process(event: GameEvent) {
        switch event {
        case .brickHit(let brickID):
            bricks.remove(withId: BrickId(of: brickID.uuidString))
            scoreCard.score(1)
        case .ballLost:
            livesCard.lifeWasLost()
        }
    }
}
