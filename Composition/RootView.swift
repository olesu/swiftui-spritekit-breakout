import SwiftUI

struct RootView: View {
    @Environment(NavigationCoordinator.self) var navigationCoordinator: NavigationCoordinator
    @Environment(RealScreenNavigationService.self) var screenNavigationService: RealScreenNavigationService
    @Environment(RealGameConfigurationService.self) var gameConfigurationService: RealGameConfigurationService
    @Environment(InMemoryStorage.self) var gameStateStorage: InMemoryStorage
    @Environment(RealGameResultService.self) var gameResultService: RealGameResultService
    @Environment(ApplicationConfiguration.self) var applicationConfiguration: ApplicationConfiguration
    
    var body: some View {
        ZStack {
            switch navigationCoordinator.currentScreen {
            case .idle:
                IdleView(screenNavigationService: screenNavigationService)
            case .game:
                GameView(
                    configurationService: gameConfigurationService,
                    screenNavigationService: screenNavigationService,
                    storage: gameStateStorage,
                    gameResultService: gameResultService
                )
            case .gameEnd:
                GameEndView(
                    screenNavigationService: screenNavigationService,
                    gameResultService: gameResultService
                )
            }
        }
        .frame(
            width: applicationConfiguration.windowWidth,
            height: applicationConfiguration.windowHeight
        )

    }
}
