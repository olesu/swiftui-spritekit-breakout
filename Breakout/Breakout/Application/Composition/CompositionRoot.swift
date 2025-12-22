import OSLog
import SwiftUI

enum CompositionRoot {

    static func makeRootDependencies() -> RootDependencies {
        let navigation = makeNavigationDependencies()
        let configuration = makeConfigurationDependencies()
        let gameResult = makeGameResultDependencies(
            screenNavigationService: navigation.screenNavigationService
        )
        let game = makeGameDependencies(
            configurationService: configuration.gameConfigurationService,
            gameResultService: gameResult.gameResultService,
            screenNavigationService: navigation.screenNavigationService
        )

        return RootDependencies(
            navigationCoordinator: navigation.navigationCoordinator,
            applicationConfiguration: configuration.applicationConfiguration,
            gameConfigurationService: configuration.gameConfigurationService,
            screenNavigationService: navigation.screenNavigationService,
            gameStateStorage: gameResult.gameStateStorage,
            gameResultService: gameResult.gameResultService,
            idleViewModel: navigation.idleViewModel,
            gameViewModel: game.viewModel,
            gameEndViewModel: gameResult.gameEndViewModel,
            sceneBuilder: game.sceneBuilder
        )
    }
}

extension CompositionRoot {
    fileprivate static func makeNavigationDependencies() -> (
        navigationCoordinator: NavigationCoordinator,
        screenNavigationService: DefaultScreenNavigationService,
        idleViewModel: IdleViewModel
    ) {
        let navigationState = NavigationState()
        let navigationCoordinator = NavigationCoordinator(
            navigationState: navigationState
        )
        let screenNavigationService = DefaultScreenNavigationService(
            navigationState: navigationState
        )
        let idleViewModel = IdleViewModel(
            screenNavigationService: DefaultScreenNavigationService(
                navigationState: navigationState
            )
        )

        return (navigationCoordinator, screenNavigationService, idleViewModel)
    }
}

extension CompositionRoot {
    fileprivate static func makeConfigurationDependencies() -> (
        applicationConfiguration: ApplicationConfiguration,
        gameConfigurationService: DefaultGameConfigurationService
    ) {
        let gameConfigurationService = DefaultGameConfigurationService(
            gameConfigurationAdapter: JsonGameConfigurationAdapter()
        )

        let applicationConfiguration = ApplicationConfiguration(
            gameConfigurationService: gameConfigurationService
        )

        return (applicationConfiguration, gameConfigurationService)
    }
}

extension CompositionRoot {
    fileprivate static func makeGameResultDependencies(
        screenNavigationService: DefaultScreenNavigationService
    ) -> (
        gameStateStorage: InMemoryStorage,
        gameResultService: RealGameResultService,
        gameEndViewModel: GameEndViewModel
    ) {
        let gameStateStorage = InMemoryStorage()
        let resultAdapter = InMemoryGameResultAdapter(storage: gameStateStorage)
        let gameResultService = RealGameResultService(adapter: resultAdapter)

        let gameEndViewModel = GameEndViewModel(
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService
        )

        return (gameStateStorage, gameResultService, gameEndViewModel)
    }
}

extension CompositionRoot {
    fileprivate static func makeGameDependencies(
        configurationService: DefaultGameConfigurationService,
        gameResultService: RealGameResultService,
        screenNavigationService: DefaultScreenNavigationService
    ) -> (
        viewModel: GameViewModel,
        sceneBuilder: GameSceneBuilder
    ) {
        let session = GameSession(
            repository: InMemoryGameStateRepository(),
            reducer: GameReducer()
        )

        let gameSceneBuilder = DefaultGameSceneBuilder(
            gameConfigurationService: configurationService,
            collisionRouter: GameWiring.makeCollisionRouter(),
            brickLayoutFactory: SKBrickLayoutFactory(session: session),
            session: session,
            ballLaunchController: BallLaunchController(),
            paddleMotionController: PaddleMotionController(speed: 450.0)
        )

        let viewModel = GameViewModel(
            session: session,
            gameConfigurationService: configurationService,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService,
            brickService: GameWiring.makeBrickService(),
        )

        return (viewModel, gameSceneBuilder)
    }

}
