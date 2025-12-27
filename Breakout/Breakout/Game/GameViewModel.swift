import Foundation
import SpriteKit
import SwiftUI

@Observable
final class GameViewModel {
    private let session: GameSession
    private let gameConfiguration: GameConfiguration
    private let screenNavigationService: ScreenNavigationService
    private let gameResultService: GameResultService
    private let brickService: BrickService
    private let startingLevel: StartingLevel

    var currentScore: Int = 0
    var remainingLives: Int = 0
    var gameStatus: GameStatus = .idle
    private var lastStatus: GameStatus = .idle

    init(
        session: GameSession,
        gameConfiguration: GameConfiguration,
        screenNavigationService: ScreenNavigationService,
        gameResultService: GameResultService,
        brickService: BrickService,
        startingLevel: StartingLevel
    ) {
        self.session = session
        self.gameConfiguration = gameConfiguration
        self.screenNavigationService = screenNavigationService
        self.gameResultService = gameResultService
        self.brickService = brickService
        self.startingLevel = startingLevel

        startTracking()
    }

}

extension GameViewModel {
    func startNewGame() throws {
        // TODO: Need to move this over to LevelBricksProvider
        let layoutFileName = startingLevel.layoutFileName
        let bricks = try brickService.load(layoutNamed: layoutFileName)

        // TODO: Use parameterless variant when bricks are being provided
        session.startGame(bricks: bricks)
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
