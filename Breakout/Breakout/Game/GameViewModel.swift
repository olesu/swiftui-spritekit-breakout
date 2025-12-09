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

    // UI callbacks to GameScene
    private var onBallResetNeeded: (() -> Void)?

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
    }

    var currentScore: Int = 0
    var remainingLives: Int = 0
    var gameStatus: GameStatus = .idle

}

extension GameViewModel {
    func startNewGame() throws -> GameScene {
        let nodes = try nodeCreator.createNodes()
        let bricks = try brickService.load(named: layoutFileName)

        // TODO: Send bricks into session.startGame instead of reset???
        // TODO: Let startGame handle resetting
        // TODO: If dictionary is needed in session, let session create it
        session.reset(
            bricks: Dictionary(uniqueKeysWithValues: bricks.map { ($0.id, $0) })
        )
        session.startGame()

        currentScore = session.state.score
        remainingLives = session.state.lives
        gameStatus = session.state.status

        let scene = gameSceneBuilder.makeScene(
            with: nodes,
            onGameEvent: { [weak self] event in self?.handleGameEvent(event) },
            onBallResetComplete: { [weak self] in self?.acknowledgeBallReset() }
        )
        wireSceneCallbacks(scene)
        
        return scene
    }

    private func handleGameEvent(_ event: GameEvent) {
        session.apply(event)

        currentScore = session.state.score
        remainingLives = session.state.lives
        gameStatus = session.state.status

        // TODO: Seems misplaced
        if session.state.ballResetNeeded {
            onBallResetNeeded?()
        }

        // Handle game over
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

    private func acknowledgeBallReset() {
        session.acknowledgeBallReset()
    }

}

extension GameViewModel {
    private func wireSceneCallbacks(_ scene: GameScene) {
        onBallResetNeeded = { [weak scene] in
            scene?.resetBall()
        }
    }
}
