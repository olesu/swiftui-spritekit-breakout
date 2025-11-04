import Foundation

class BreakoutGameEngine {
    private var bricks: Bricks
    private var scoreCard: ScoreCard
    private var livesCard: LivesCard
    private var gameState: GameState

    var remainingBrickCount: Int {
        bricks.someRemaining ? 1 : 0
    }

    var currentScore: Int {
        scoreCard.total
    }

    var remainingLives: Int {
        livesCard.remaining
    }

    var currentStatus: GameState {
        gameState
    }

    init(bricks: Bricks, lives: Int = 3) {
        self.bricks = bricks
        self.scoreCard = ScoreCard()
        self.livesCard = LivesCard(lives)
        self.gameState = .playing
    }

    func process(event: GameEvent) {
        switch event {
        case .brickHit(let brickID):
            bricks.remove(withId: BrickId(of: brickID.uuidString))
            scoreCard.score(1)

            if !bricks.someRemaining {
                gameState = .won
            }
        case .ballLost:
            livesCard.lifeWasLost()

            if livesCard.gameOver {
                gameState = .gameOver
            }
        }
    }
}
