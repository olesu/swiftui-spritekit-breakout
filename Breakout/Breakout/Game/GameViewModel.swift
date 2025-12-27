import Foundation
import SpriteKit
import SwiftUI

@Observable
final class GameViewModel {
    private let session: GameSession
    private let gameConfiguration: GameConfiguration
    private let screenNavigationService: ScreenNavigationService
    private let gameResultService: GameResultService

    var currentScore: Int = 0
    var remainingLives: Int = 0
    var gameStatus: GameStatus = .idle
    private var lastStatus: GameStatus = .idle

    init(
        session: GameSession,
        gameConfiguration: GameConfiguration,
        screenNavigationService: ScreenNavigationService,
        gameResultService: GameResultService,
    ) {
        self.session = session
        self.gameConfiguration = gameConfiguration
        self.screenNavigationService = screenNavigationService
        self.gameResultService = gameResultService

        startTracking()
    }

}

extension GameViewModel {
    func startNewGame() {
        session.startGame()
    }

}

extension GameViewModel {
    private func startTracking() {
        withObservationTracking {
            updateFromSession()
        } onChange: { [weak self] in
            Task { @MainActor [weak self] in
                self?.startTracking()
            }
        }
    }

    private func updateFromSession() {
        let s = session.state
        
        if gameStatus != s.status {
            handleStateSideEffects(newState: s)
        }

        currentScore = s.score
        remainingLives = s.lives
        gameStatus = s.status
    }

    private func handleStateSideEffects(newState: GameState) {
        switch newState.status {
        case .gameOver, .won:
            gameResultService.save(
                didWin: newState.status == .won,
                score: newState.score
            )
            screenNavigationService.navigate(to: .gameEnd)
        default:
            break
        }
    }
}
