import SwiftUI
import Foundation

#if DEBUG
    #Preview {
        let configurationService = PreviewGameConfigurationService()
        let screenNavigationService = RealScreenNavigationService(
            navigationState: NavigationState()
        )
        let storage = InMemoryStorage()
        let gameResultAdapter = InMemoryGameResultAdapter(storage: storage)
        let gameResultService = RealGameResultService(adapter: gameResultAdapter)
        GameView(
            gameService: BreakoutGameService(),
            configurationService: configurationService,
            screenNavigationService: screenNavigationService,
            storage: storage,
            gameResultService: gameResultService
        )
        .frame(
            width: configurationService.getGameConfiguration().sceneWidth
                * configurationService.getGameScale(),
            height: configurationService.getGameConfiguration().sceneHeight
                * configurationService.getGameScale()
        )
    }

    private class PreviewGameConfigurationService: GameConfigurationService {
        func getGameConfiguration() -> GameConfiguration {
            GameConfiguration(
                sceneWidth: 320,
                sceneHeight: 480,
                brickArea: BrickArea(
                    x: 20,
                    y: 330,
                    width: 280,
                    height: 120
                )
            )
        }

        func getGameScale() -> CGFloat {
            0.5
        }
    }

#endif
