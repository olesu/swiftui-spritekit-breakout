import Foundation
import SpriteKit
import SwiftUI

@Observable
final class GameViewModel {
    private let session: GameSession
    private let screenNavigationService: ScreenNavigationService
    private let gameResultService: GameResultService
    private let nodeCreator: NodeCreator
    private let brickService: BrickService
    private let gameSceneBuilder: GameSceneBuilder

    // UI configuration (safe as stored properties)
    let sceneSize: CGSize
    let brickArea: CGRect
    let layoutFileName: String
    
    var currentScore: Int = 0
    var remainingLives: Int = 0
    var gameStatus: GameStatus = .idle
    private var lastStatus: GameStatus = .idle

    init(
        session: GameSession,
        configurationService: GameConfigurationService,
        screenNavigationService: ScreenNavigationService,
        gameResultService: GameResultService,
        nodeCreator: NodeCreator,
        brickService: BrickService,
        gameSceneBuilder: GameSceneBuilder
    ) {
        self.session = session
        self.screenNavigationService = screenNavigationService
        self.gameResultService = gameResultService

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
        self.layoutFileName = config.layoutFileName
        self.nodeCreator = nodeCreator
        self.brickService = brickService
        self.gameSceneBuilder = gameSceneBuilder

        startTracking()
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

extension GameViewModel {
    func startNewGame() throws -> GameScene {
        let nodes = try nodeCreator.createNodes()
        let bricks = try brickService.load(named: layoutFileName)

        session.startGame(bricks: bricks)

        currentScore = session.state.score
        remainingLives = session.state.lives
        gameStatus = session.state.status

        let scene = gameSceneBuilder.makeScene(
            with: nodes,
            gameSession: session
        )

        return scene
    }

}
