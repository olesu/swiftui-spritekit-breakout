import Foundation
import SwiftUI
import SpriteKit

@Observable
final class GameViewModel {
    private let session: GameSession
    private let screenNavigationService: ScreenNavigationService
    private let gameResultService: GameResultService
    private let nodeCreator: NodeCreator
    private let collisionRouter: CollisionRouter
    private let bricks: [Brick]

    // UI configuration (safe as stored properties)
    let sceneSize: CGSize
    let brickArea: CGRect

    // UI callbacks to GameScene
    var onBallResetNeeded: (() -> Void)?

    init(
        session: GameSession,
        configurationService: GameConfigurationService,
        screenNavigationService: ScreenNavigationService,
        gameResultService: GameResultService,
        nodeCreator: NodeCreator,
        collisionRouter: CollisionRouter,
        bricks: [Brick]
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
        self.collisionRouter = collisionRouter
        self.bricks = bricks
    }

    var currentScore: Int = 0
    var remainingLives: Int = 0
    var gameStatus: GameStatus = .idle

    // MARK: - Game Flow
    
    func startNewGame() -> GameScene {
        let nodes = nodeCreator.createNodes()

        session.reset(bricks: Dictionary(uniqueKeysWithValues: bricks.map { ($0.id, $0) }))
        session.startGame()
        updateUIFromDomain()
        checkGameEnd()

        return makeScene(with: nodes)
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
    
    func todoRemoveMeWhenSceneCreationIsInViewModelCollisionRouter() -> CollisionRouter {
        collisionRouter
    }
    
}

extension GameViewModel {
    func makeScene(with nodes: [NodeNames: SKNode]) -> GameScene {
        let scene = GameScene(
            size: sceneSize,
            nodes: nodes,
            onGameEvent: { [weak self] event in self?.handleGameEvent(event) },
            collisionRouter: collisionRouter
            )
        
        wireSceneCallbacks(scene)
        
        return scene
    }
    
    private func wireSceneCallbacks(_ scene: GameScene) {
        scene.onBallResetComplete = { [weak self] in
            self?.acknowledgeBallReset()
        }
        onBallResetNeeded = { [weak scene] in
            scene?.resetBall()
        }
    }


}
