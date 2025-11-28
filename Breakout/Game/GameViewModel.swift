import Foundation
import SwiftUI

/// Coordinates between the SwiftUI view layer and the domain game engine.
///
/// Maintains observable state for SwiftUI views and provides callbacks for
/// SpriteKit GameScene updates. Bridges the gap between declarative SwiftUI
/// and imperative SpriteKit.
@Observable internal final class GameViewModel {
    private let service: GameService
    private let repository: GameStateRepository
    private let screenNavigationService: ScreenNavigationService
    private let gameResultService: GameResultService

    // Configuration (loaded once at initialization)
    internal let sceneSize: CGSize
    internal let brickArea: CGRect

    // Runtime state
    private var currentState: GameState {
        repository.load()
    }
    
    private var engine: GameEngine?
    internal var currentScore: Int {
        currentState.score
    }
    internal var remainingLives: Int {
        currentState.lives
    }

    // Closure-based callbacks for GameScene (non-SwiftUI communication)
    internal var onScoreChanged: ((Int) -> Void)?
    internal var onLivesChanged: ((Int) -> Void)?
    internal var onBallResetNeeded: (() -> Void)?

    /// Initializes the view model with service, repository, and configuration.
    /// - Parameters:
    ///   - service: The game service for stateless game logic.
    ///   - repository: Repository for loading/saving game state.
    ///   - configurationService: Service providing scene dimensions and layout configuration.
    ///   - screenNavigationService: Service for screen navigation.
    ///   - gameResultService: Service for saving game results.
    internal init(
        service: GameService,
        repository: GameStateRepository,
        configurationService: GameConfigurationService,
        screenNavigationService: ScreenNavigationService,
        gameResultService: GameResultService
    ) {
        self.service = service
        self.repository = repository

        let config = configurationService.getGameConfiguration()
        self.sceneSize = CGSize(
            width: config.sceneWidth,
            height: config.sceneHeight
        )
        self.brickArea = CGRect(
            x: config.brickArea.x,
            y: config.brickArea.y,
            width: config.brickArea.width,
            height: config.brickArea.height
        )
        self.screenNavigationService = screenNavigationService
        self.gameResultService = gameResultService
    }

    /// DEPRECATED: Temporary backward compatibility initializer
    internal convenience init(
        configurationService: GameConfigurationService,
        screenNavigationService: ScreenNavigationService,
        gameResultService: GameResultService
    ) {
        self.init(
            service: BreakoutGameService(),
            repository: InMemoryGameStateRepository(),
            configurationService: configurationService,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService
        )
    }

    /// Sets the game engine for this view model.
    /// - Parameter engine: The game engine instance to use.
    internal func setEngine(_ engine: GameEngine) {
        self.engine = engine
    }

    /// Handles a game event from the SpriteKit layer.
    ///
    /// Processes the event through the game engine, updates observable properties
    /// for SwiftUI, invokes callbacks for SpriteKit scene updates, and triggers
    /// ball reset if needed.
    /// - Parameter event: The game event to handle.
    internal func handleGameEvent(_ event: GameEvent) {
        guard let engine = engine else { return }

        engine.process(event: event)

        handleScoreChange(engine)
        handleLivesChange(engine)
        handleBallReset(engine)
        handleScreenNavigation(engine)
    }
    
    internal func startGame() {
        let state = service.startGame(state: currentState)
        repository.save(state)
    }
    
    private func handleScoreChange(_ engine: GameEngine) {
        onScoreChanged?(engine.currentScore)
    }
    
    private func handleLivesChange(_ engine: GameEngine) {
        onLivesChanged?(engine.remainingLives)
    }
    
    private func handleBallReset(_ engine: GameEngine) {
        if engine.shouldResetBall {
            onBallResetNeeded?()
            engine.acknowledgeBallReset()
        }
    }
    
    private func handleScreenNavigation(_ engine: GameEngine) {
        if engine.currentStatus == .gameOver || engine.currentStatus == .won {
            gameResultService.save(
                didWin: engine.currentStatus == .won,
                score: engine.currentScore
            )
            screenNavigationService.navigate(to: .gameEnd)
        }
    }

}
