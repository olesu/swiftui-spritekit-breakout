import Foundation
import SwiftUI

@Observable
final class GameViewModel {
    private let session: GameSession
    private let screenNavigationService: ScreenNavigationService
    private let gameResultService: GameResultService

    // UI configuration (safe as stored properties)
    internal let sceneSize: CGSize
    internal let brickArea: CGRect

    // UI callbacks to GameScene
    internal var onScoreChanged: ((Int) -> Void)?
    internal var onLivesChanged: ((Int) -> Void)?
    internal var onBallResetNeeded: (() -> Void)?

    init(
        session: GameSession,
        configurationService: GameConfigurationService,
        screenNavigationService: ScreenNavigationService,
        gameResultService: GameResultService
    ) {
        self.session = session
        self.screenNavigationService = screenNavigationService
        self.gameResultService = gameResultService

        let config = configurationService.getGameConfiguration()
        self.sceneSize = CGSize(width: config.sceneWidth, height: config.sceneHeight)
        self.brickArea = CGRect(
            x: config.brickArea.x,
            y: config.brickArea.y,
            width: config.brickArea.width,
            height: config.brickArea.height
        )
    }

    // MARK: - UI-derived computed properties

    internal var currentScore: Int {
        session.state.score
    }

    internal var remainingLives: Int {
        session.state.lives
    }

    internal var gameStatus: GameStatus {
        session.state.status
    }

    // MARK: - Game Flow

    internal func startGame() {
        session.startGame()
        syncCallbacks()
        checkGameEnd()
    }

    internal func handleGameEvent(_ event: GameEvent) {
        session.apply(event)
        syncCallbacks()
        checkGameEnd()
    }

    internal func resetGame(with bricks: [BrickId: Brick]) {
        session.reset(bricks: bricks)
        syncCallbacks()
    }

    internal func acknowledgeBallReset() {
        session.acknowledgeBallReset()
        syncCallbacks()
    }

    // MARK: - Callback Synchronization

    private func syncCallbacks() {
        onScoreChanged?(session.state.score)
        onLivesChanged?(session.state.lives)

        if session.state.ballResetNeeded {
            onBallResetNeeded?()
        }
    }

    // MARK: - Navigation + Result Saving

    private func checkGameEnd() {
        let state = session.state
        switch state.status {
        case .gameOver, .won:
            gameResultService.save(
                didWin: state.status == .won,
                score: state.score
            )
            screenNavigationService.navigate(to: .gameEnd)
        default:
            break
        }
    }
}
