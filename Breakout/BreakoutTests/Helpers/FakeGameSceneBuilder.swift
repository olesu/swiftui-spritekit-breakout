import Foundation
import SpriteKit

@testable import Breakout

final class FakeGameSceneBuilder: GameSceneBuilder {
    func makeScene() -> SKGameScene {
        let ballLaunchController = BallLaunchController()
        let paddleMotionController = PaddleMotionController(speed: 0)
        let paddleInputController = PaddleInputController()
        let paddleBounceApplier = PaddleBounceApplier(
            bounceSpeedPolicy: GameTuning.testNeutral.bounceSpeedPolicy,
            bounceCalculator: BounceCalculator()
        )

        let collisionRouter = FakeCollisionRouter()
        let game = FakeRunningGame()
        let gameEventSink = FakeGameEventSink()
        let nodes = SceneNodes.createValid()
        let nodeManager = SKNodeManager(
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController,
            paddleBounceApplier: paddleBounceApplier,
            nodes: nodes
        )
        return SKGameScene(
            size: Size(width: 320, height: 480),
            nodes: nodes,
            ballLaunchController: ballLaunchController,
            contactHandler: SKGamePhysicsContactHandler(
                collisionRouter: collisionRouter,
                nodeManager: nodeManager,
                gameEventHandler: GameEventHandler(
                    gameEventSink: gameEventSink,
                    nodeManager: nodeManager,
                    soundEffectProducer: FakeSoundEffectProducer(),
                    visualEffectProducer: FakeVisualEffectProducer(),
                )
            ),
            gameController: GameController(
                paddleInputController: paddleInputController,
                game: game,
                nodeManager: nodeManager,
            ),
        )
    }

}

private final class FakeRunningGame: RunningGame {
    var ballResetNeeded: Bool = false
    var visualGameState: VisualGameState {
        .init(levelId: LevelId.only)
    }
    
    func announceBallResetInProgress() {
        
    }
    
    func acknowledgeBallReset() {
        
    }
    
    func consumeLevelDidChange() -> Bool {
        false
    }
}
