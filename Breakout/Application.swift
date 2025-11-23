import Foundation
import SwiftUI

@main
struct Application: App {
    private let navigationCoordinator: NavigationCoordinator
    private let applicationConfiguration: ApplicationConfiguration
    private let gameConfigurationService: GameConfigurationService
    private let screenNavigationService: ScreenNavigationService
    private let gameStateStorage: InMemoryStorage
    private let gameResultService: GameResultService

    init() {
        // Navigation state - simple observable for screen transitions
        let navigationState = NavigationState()
        let screenNavigationService = RealScreenNavigationService(navigationState: navigationState)

        // Game state storage - used by engine for game state persistence
        let gameStateStorage = InMemoryStorage()

        // Game result service - tracks game outcome for end screen
        let gameResultAdapter = InMemoryGameResultAdapter(storage: gameStateStorage)
        let gameResultService = RealGameResultService(adapter: gameResultAdapter)

        // Configuration services
        let gameConfigurationService = RealGameConfigurationService(
            loader: JsonGameConfigurationAdapter()
        )
        let applicationConfiguration = ApplicationConfiguration(
            gameConfigurationService: gameConfigurationService
        )

        self.screenNavigationService = screenNavigationService
        self.gameStateStorage = gameStateStorage
        self.gameResultService = gameResultService
        self.gameConfigurationService = gameConfigurationService
        self.applicationConfiguration = applicationConfiguration
        navigationCoordinator = NavigationCoordinator(navigationState: navigationState)
    }

    var body: some Scene {
        WindowGroup {
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
}
