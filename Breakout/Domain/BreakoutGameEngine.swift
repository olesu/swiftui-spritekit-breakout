import Foundation

/// The concrete implementation of the Breakout game engine.
///
/// Manages the core game loop by processing events from the SpriteKit layer
/// and updating game state accordingly. Maintains score, lives, and brick
/// registry. Enforces state transitions (.idle → .playing → .won/.gameOver).
internal final class BreakoutGameEngine: GameEngine {
    private var bricks: Bricks
    private var scoreCard: ScoreCard
    private var livesCard: LivesCard
    private var gameState: GameState
    private var ballResetNeeded: Bool = false

    internal var currentScore: Int {
        scoreCard.total
    }

    internal var remainingLives: Int {
        livesCard.remaining
    }

    internal var shouldResetBall: Bool {
        ballResetNeeded
    }

    internal func acknowledgeBallReset() {
        ballResetNeeded = false
    }

    /// Initializes a new game engine with the specified brick configuration.
    /// - Parameters:
    ///   - bricks: The brick registry containing all bricks for this game session.
    ///   - lives: The starting number of lives for the player (default: 3).
    internal init(bricks: Bricks, lives: Int = 3) {
        self.bricks = bricks
        self.scoreCard = ScoreCard()
        self.livesCard = LivesCard(lives)
        self.gameState = .idle
    }

    internal func start() {
        guard gameState == .idle else {
            return
        }
        gameState = .playing
    }

    internal func process(event: GameEvent) {
        guard gameState == .playing else {
            return
        }

        switch event {
        case .brickHit(let brickID):
            let brickId = BrickId(of: brickID.uuidString)

            guard let brick = bricks.get(byId: brickId) else {
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
            } else {
                ballResetNeeded = true
            }
        }
    }
}
