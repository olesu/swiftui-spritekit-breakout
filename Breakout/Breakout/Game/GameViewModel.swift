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
    }

}

extension GameViewModel {
    func startNewGame() {
        session.startGame()
        syncFromSession()
    }

}

extension GameViewModel: GameSessionObserver {
    func gameSessionDidUpdate() {
        syncFromSession()
    }

    @MainActor
    func syncFromSession() {
        apply(snapshot: session.snapshot())
    }

    private func updateFromSession() {
        apply(snapshot: session.snapshot())
    }

    private func apply(snapshot: GameSessionSnapshot) {
        if gameStatus != snapshot.status {
            handleStateSideEffects(snapshot: snapshot)
        }

        currentScore = snapshot.score
        remainingLives = snapshot.lives
        gameStatus = snapshot.status
    }

    private func handleStateSideEffects(snapshot: GameSessionSnapshot) {
        switch snapshot.status {
        case .gameOver, .won:
            gameResultService.save(
                didWin: snapshot.status == .won,
                score: snapshot.score
            )
            screenNavigationService.navigate(to: .gameEnd)
        default:
            break
        }
    }
}
