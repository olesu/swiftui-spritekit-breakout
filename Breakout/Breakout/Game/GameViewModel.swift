import Foundation
import SwiftUI
import SpriteKit

@Observable
final class GameViewModel {
    private let session: GameSession
    private let screenNavigationService: ScreenNavigationService
    private let gameResultService: GameResultService
    private let nodeCreator: NodeCreator

    // UI configuration (safe as stored properties)
    internal let sceneSize: CGSize
    internal let brickArea: CGRect

    // UI callbacks to GameScene
    var onBallResetNeeded: (() -> Void)?

    init(
        session: GameSession,
        configurationService: GameConfigurationService,
        screenNavigationService: ScreenNavigationService,
        gameResultService: GameResultService,
        nodeCreator: NodeCreator
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
        self.nodeCreator = nodeCreator
    }

    var currentScore: Int = 0
    var remainingLives: Int = 0
    var gameStatus: GameStatus = .idle

    // MARK: - Game Flow
    
    func startNewGame(onSceneNodesCreated: @escaping ([NodeNames: SKNode]) -> Void) {
        var bricks: [BrickId: Brick] = [:]
        let nodes = nodeCreator.createNodes { brick in
            bricks[brick.id] = brick
        }

        session.reset(bricks: bricks)
        session.startGame()
        updateUIFromDomain()
        checkGameEnd()

        onSceneNodesCreated(nodes)
    }

    internal func handleGameEvent(_ event: GameEvent) {
        session.apply(event)
        updateUIFromDomain()
        checkGameEnd()
    }

    internal func resetGame(with bricks: [BrickId: Brick]) {
        session.reset(bricks: bricks)
        updateUIFromDomain()
    }

    internal func acknowledgeBallReset() {
        session.acknowledgeBallReset()
        updateUIFromDomain()
    }

    // MARK: - Callback Synchronization

    private func updateUIFromDomain() {
        currentScore = session.state.score
        remainingLives = session.state.lives
        gameStatus = session.state.status
        
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
