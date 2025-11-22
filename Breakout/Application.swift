import Foundation
import SwiftUI

@main
struct Application: App {
    private let navigationCoordinator: NavigationCoordinator
    private let gameModel: GameConfigurationModel
    private let idleViewModel: IdleViewModel
    private let gameStateStorage: InMemoryStorage

    init() {
        // Navigation state - simple observable for screen transitions
        let navigationState = NavigationState()
        let screenNavigationService = RealScreenNavigationService(navigationState: navigationState)

        // Game state storage - used by engine for game state persistence
        let gameStateStorage = InMemoryStorage()

        self.gameStateStorage = gameStateStorage
        navigationCoordinator = NavigationCoordinator(navigationState: navigationState)

        gameModel = GameConfigurationModel(
            service: RealGameConfigurationService(
                loader: JsonGameConfigurationAdapter()
            )
        )

        idleViewModel = IdleViewModel(screenNavigationService: screenNavigationService)
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch navigationCoordinator.currentScreen {
                case .idle:
                    IdleViewWrapper()
                        .environment(idleViewModel)
                case .game:
                    GameViewWrapper()
                        .environment(gameModel)
                        .environment(gameStateStorage)
                }
            }
            .frame(
                width: gameModel.frameWidth,
                height: gameModel.frameHeight
            )
        }
    }
}
