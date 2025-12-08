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
        let bricks: [Brick] = []
        let viewModel = GameViewModel(
            session: session,
            configurationService: configurationService,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService,
            nodeCreator: SpriteKitNodeCreator(bricks: bricks),
            collisionRouter: DefaultCollisionRouter(
                brickIdentifier: NodeNameBrickIdentifier()
            ),
            bricks: bricks
        )

        GameView()
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
