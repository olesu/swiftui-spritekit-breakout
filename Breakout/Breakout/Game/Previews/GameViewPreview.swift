import Foundation
import SwiftUI

#if DEBUG
    #Preview {
        let configurationService = PreviewGameConfigurationService()
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
            gameConfigurationService: configurationService,
            collisionRouter: GameWiring.makeCollisionRouter(),
            brickLayoutFactory: brickLayoutFactory,
            session: session,
            ballLaunchController: ballLaunchController,
            paddleMotionController: PaddleMotionController(speed: 450.0)
        )
        let viewModel = GameViewModel(
            session: session,
            gameConfigurationService: configurationService,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService,
            brickService: GameWiring.makeBrickService(),
        )

        GameView(sceneBuilder: sceneBuilder)
            .environment(viewModel)
            .frame(
                width: configurationService.getGameConfiguration().sceneWidth
                    * configurationService.getGameScale(),
                height: configurationService.getGameConfiguration().sceneHeight
                    * configurationService.getGameScale()
            )
    }

    private class PreviewGameConfigurationService: GameConfigurationService {
        func getGameConfiguration() -> GameConfiguration {
            GameConfiguration.defaultValue()
        }

        func getGameScale() -> CGFloat {
            0.5
        }
    }

#endif
