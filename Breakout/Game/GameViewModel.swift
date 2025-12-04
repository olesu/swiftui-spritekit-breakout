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

    /// Handles a game event from the SpriteKit layer.
    ///
    /// Processes the event through the stateless game service, updates state
    /// in the repository, and triggers callbacks for UI updates.
    /// - Parameter event: The game event to handle.
    internal func handleGameEvent(_ event: GameEvent) {
        processEvent(event)
        updateScore()
        updateLives()
        checkBallReset()
        checkGameEnd()
    }

    private func processEvent(_ event: GameEvent) {
        let state = service.processEvent(event, state: currentState)
        repository.save(state)
    }
    
    func resetGame() {
        repository.save(GameState.initial)
    }
    
    internal func startGame() {
        let state = service.startGame(state: currentState)
        repository.save(state)
    }

    internal func acknowledgeBallReset() {
        let state = service.acknowledgeBallReset(state: currentState)
        repository.save(state)
    }

    internal func initializeBricks(_ bricksDict: [BrickId: Brick]) {
        let state = currentState.with(bricks: bricksDict)
        repository.save(state)
    }

    private func updateScore() {
        onScoreChanged?(currentState.score)
    }

    private func updateLives() {
        onLivesChanged?(currentState.lives)
    }

    private func checkBallReset() {
        let state = currentState
        if state.ballResetNeeded {
            onBallResetNeeded?()
        }
    }

    private func checkGameEnd() {
        let state = currentState
        if state.status == .gameOver || state.status == .won {
            gameResultService.save(
                didWin: state.status == .won,
                score: state.score
            )
            screenNavigationService.navigate(to: .gameEnd)
        }
    }

}
