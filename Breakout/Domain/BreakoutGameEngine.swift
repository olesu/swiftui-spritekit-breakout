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
    private var gameStatus: GameStatus {
        didSet {
            statusAdapter.save(gameStatus)
        }
    }
    private var ballResetNeeded: Bool = false
    private let statusAdapter: GameStatusAdapter

    internal var currentScore: Int {
        scoreCard.total
    }

    internal var remainingLives: Int {
        livesCard.remaining
    }

    internal var currentStatus: GameStatus {
        gameStatus
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
    ///   - statusAdapter: The adapter for persisting game state.
    ///   - lives: The starting number of lives for the player (default: 3).
    internal init(bricks: Bricks, statusAdapter: GameStatusAdapter, lives: Int = 3) {
        self.bricks = bricks
        self.scoreCard = ScoreCard()
        self.livesCard = LivesCard(lives)
        self.statusAdapter = statusAdapter
        self.gameStatus = .idle
        statusAdapter.save(.idle)
    }

    internal func start() {
        guard gameStatus == .idle else {
            return
        }
        gameStatus = .playing
    }

    internal func process(event: GameEvent) {
        guard gameStatus == .playing else {
            return
        }

        switch event {
        case .brickHit(let brickID):
            let id = brickID

            guard let brick = bricks.get(byId: id) else {
                return
            }

            bricks.remove(withId: id)
            scoreCard.score(brick.color.pointValue)

            if !bricks.someRemaining {
                gameStatus = .won
            }
        case .ballLost:
            livesCard.lifeWasLost()

            if livesCard.gameOver {
                gameStatus = .gameOver
            } else {
                ballResetNeeded = true
            }
        }
    }
}
