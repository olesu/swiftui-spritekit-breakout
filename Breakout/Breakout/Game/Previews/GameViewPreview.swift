import Foundation
import SwiftUI

#if DEBUG
    #Preview {
        let gameTuning = GameTuning.classic
        let gameConfiguration = GameConfiguration.defaultValue()

        let screenNavigationService = DefaultScreenNavigationService(
            navigationState: NavigationState()
        )
        let storage = InMemoryStorage()
        let gameResultAdapter = InMemoryGameResultAdapter(storage: storage)
        let gameResultService = RealGameResultService(
            adapter: gameResultAdapter
        )
        let session = GameSession(
            repository: InMemoryGameStateRepository(),
            reducer: GameReducer(),
            levelOrder: [],
            levelBricksProvider: DefaultLevelBricksProvider.empty,
        )
        let brickLayoutFactory = SKBrickLayoutFactory(session: session)
        let ballLaunchController = BallLaunchController()
        let sceneBuilder = DefaultGameSceneBuilder(
            gameConfiguration: gameConfiguration,
            collisionRouter: GameWiring.makeCollisionRouter(),
            brickLayoutFactory: brickLayoutFactory,
            session: session,
            ballLaunchController: ballLaunchController,
            paddleMotionController: PaddleMotionController(
                speed: gameTuning.paddleSpeed
            ),
            bounceSpeedPolicy: gameTuning.bounceSpeedPolicy
        )
        let viewModel = GameViewModel(
            session: session,
            gameConfiguration: gameConfiguration,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService,
        )

        GameView(sceneBuilder: sceneBuilder)
            .environment(viewModel)
            .frame(
                width: gameConfiguration.sceneWidth
                * GameScalePolicy.preview.scale,
                height: gameConfiguration.sceneHeight
                * GameScalePolicy.preview.scale
            )
    }

extension GameConfiguration {
    static func defaultValue() -> GameConfiguration {
        GameConfiguration(
            sceneWidth: 320,
            sceneHeight: 480,
            brickArea: BrickArea(
                x: 20,
                y: 330,
                width: 280,
                height: 120
            ),
            sceneLayout: SceneLayout(
                paddleStartPosition: Point(x: 160, y: 40),
                paddleSize: Size(width: 60, height: 12),
                ballStartPosition: Point(x: 160, y: 50),
                topWallPosition: Point(x: 160, y: 430),
                topWallSize: Size(width: 320, height: 10),
                leftWallPosition: Point(x: 0, y: 245),
                leftWallSize: Size(width: 10, height: 470),
                rightWallPosition: Point(x: 320, y: 245),
                rightWallSize: Size(width: 10, height: 470),
                gutterPosition: Point(x: 160, y: 0),
                gutterSize: Size(width: 320, height: 10),
            )
        )
    }
}

#endif
