import SwiftUI

enum CompositionRoot {
    static func makeRootDependencies() -> RootDependencies {
        // TODO: Extract to NavigationDependencies
        let navigationState = NavigationState()
        let navigationCoordinator = NavigationCoordinator(
            navigationState: navigationState
        )
        let screenNavigationService = RealScreenNavigationService(
            navigationState: navigationState
        )
        let idleViewModel = IdleViewModel(screenNavigationService: screenNavigationService)

        // TODO: Extract to GameConfigurationDependencies
        let gameConfigurationService = RealGameConfigurationService(
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
        
        let breakoutGameService = BreakoutGameService()
        let gameViewModel = GameViewModel(
            service: breakoutGameService,
            repository: gameStateRepository,
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
            gameService: breakoutGameService,
            idleViewModel: idleViewModel,
            gameViewModel: gameViewModel,
            gameEndViewModel: gameEndViewModel
        )
    }
}
