import SwiftUI

enum CompositionRoot {
    static func makeRootDependencies() -> RootDependencies {
        // TODO: Extract to NavigationDependencies
        let navigationState = NavigationState()
        let navigationCoordinator = NavigationCoordinator(
            navigationState: navigationState
        )
        let screenNavigationService = DefaultScreenNavigationService(
            navigationState: navigationState
        )
        let idleViewModel = IdleViewModel(screenNavigationService: screenNavigationService)

        // TODO: Extract to GameConfigurationDependencies
        let gameConfigurationService = DefaultGameConfigurationService(
            loader: JsonGameConfigurationAdapter()
        )
        let applicationConfiguration = ApplicationConfiguration(
            gameConfigurationService: gameConfigurationService
        )
        
        // TODO: Extract to GameResultDependencies
        let gameStateStorage = InMemoryStorage()
        let gameResultAdapter = InMemoryGameResultAdapter(
            storage: gameStateStorage
        )
        let gameResultService = RealGameResultService(
            adapter: gameResultAdapter
        )
        
        let gameEndViewModel = GameEndViewModel(
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService
        )
        
        let gameStateRepository = InMemoryGameStateRepository()
        
        let gameReducer = GameReducer()
        let gameSession = GameSession(repository: gameStateRepository, reducer: gameReducer)
        let gameViewModel = GameViewModel(
            session: gameSession,
            configurationService: gameConfigurationService,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService
        )


        return RootDependencies(
            navigationCoordinator: navigationCoordinator,
            applicationConfiguration: applicationConfiguration,
            gameConfigurationService: gameConfigurationService,
            screenNavigationService: screenNavigationService,
            gameStateStorage: gameStateStorage,
            gameResultService: gameResultService,
            gameService: gameReducer,
            idleViewModel: idleViewModel,
            gameViewModel: gameViewModel,
            gameEndViewModel: gameEndViewModel
        )
    }
}
