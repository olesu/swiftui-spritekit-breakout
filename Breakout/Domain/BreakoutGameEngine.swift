import Foundation

class BreakoutGameEngine: GameEngine {
    private var bricks: Bricks
    private var scoreCard: ScoreCard
    private var livesCard: LivesCard
    private var gameState: GameState

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
        self.gameState = .idle
    }

    func start() {
        guard gameState == .idle else {
            return
        }
        gameState = .playing
    }

    func process(event: GameEvent) {
        guard gameState == .playing else {
            return
        }

        switch event {
        case .brickHit(let brickID):
            let brickId = BrickId(of: brickID.uuidString)

            guard let brick = bricks.bricks[brickId] else {
                return
            }

            bricks.remove(withId: brickId)
            scoreCard.score(brick.color.pointValue)

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
