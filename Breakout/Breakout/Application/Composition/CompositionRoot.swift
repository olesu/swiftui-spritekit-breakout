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
            gameService: game.reducer,
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
            screenNavigationService: screenNavigationService
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
        reducer: GameReducer,
        viewModel: GameViewModel,
        sceneBuilder: GameSceneBuilder
    ) {
        let repository = InMemoryGameStateRepository()
        let reducer = GameReducer()

        let session = GameSession(
            repository: repository,
            reducer: reducer
        )

        let brickService = BrickService(adapter: JsonBrickLayoutAdapter())

        let brickLayoutFactory = ClassicBrickLayoutFactory(session: session)

        let collisionRouter = DefaultCollisionRouter(
            brickIdentifier: NodeNameBrickIdentifier()
        )
        
        let ballLaunchController = BallLaunchController()
        let paddleMotionController = PaddleMotionController(speed: 450.0)

        let gameSceneBuilder = DefaultGameSceneBuilder(
            gameConfigurationService: configurationService,
            collisionRouter: collisionRouter,
            brickLayoutFactory: brickLayoutFactory,
            session: session,
            ballLaunchController: ballLaunchController,
            paddleMotionController: paddleMotionController
        )

        let viewModel = GameViewModel(
            session: session,
            gameConfigurationService: configurationService,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService,
            brickService: brickService,
        )

        return (reducer, viewModel, gameSceneBuilder)
    }

}
