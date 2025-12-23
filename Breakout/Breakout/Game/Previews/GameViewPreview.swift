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
            reducer: GameReducer()
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
            brickService: GameWiring.makeBrickService(),
            startingLevel: GameWiring.makeStartingLevel(policy: .production)
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


#endif
