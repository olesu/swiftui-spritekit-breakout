import OSLog
import SwiftUI

enum ApplicationComposer {

    static func compose(
        brickService: BrickService = GameWiring.makeBrickService(),
        startingLevel: StartingLevel,
        gameConfigurationLoader: GameConfigurationLoader
    ) throws -> AppContext {
        let navigation = makeNavigationDependencies()
        let configuration = try makeConfigurationDependencies(gameConfigurationLoader: gameConfigurationLoader)
        let gameResult = makeGameResultDependencies(
            screenNavigationService: navigation.screenNavigationService
        )
        let game = makeGameDependencies(
            gameConfiguration: configuration.gameConfiguration,
            gameResultService: gameResult.gameResultService,
            screenNavigationService: navigation.screenNavigationService,
            brickService: brickService,
            startingLevel: startingLevel,
        )

        return AppContext(
            navigationCoordinator: navigation.navigationCoordinator,
            applicationConfiguration: configuration.applicationConfiguration,
            gameConfiguration: configuration.gameConfiguration,
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

extension ApplicationComposer {
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

extension ApplicationComposer {
    fileprivate static func makeConfigurationDependencies(
        gameConfigurationLoader: GameConfigurationLoader
    ) throws -> (
        applicationConfiguration: ApplicationConfiguration,
        gameConfiguration: GameConfiguration
    ) {
        let gameConfiguration = try gameConfigurationLoader.load()

        let applicationConfiguration = ApplicationConfiguration(
            gameConfiguration: gameConfiguration,
            gameScalePolicy: GameScalePolicy.deviceScale
        )

        return (applicationConfiguration, gameConfiguration)
    }
}

extension ApplicationComposer {
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

extension ApplicationComposer {
    fileprivate static func makeGameDependencies(
        gameConfiguration: GameConfiguration,
        gameResultService: RealGameResultService,
        screenNavigationService: DefaultScreenNavigationService,
        brickService: BrickService,
        startingLevel: StartingLevel,
    ) -> (
        viewModel: GameViewModel,
        sceneBuilder: GameSceneBuilder
    ) {
        let gameTuning = GameTuning.classic

        let session = GameSession(
            repository: InMemoryGameStateRepository(),
            reducer: GameReducer()
        )

        let gameSceneBuilder = DefaultGameSceneBuilder(
            gameConfiguration: gameConfiguration,
            collisionRouter: GameWiring.makeCollisionRouter(),
            brickLayoutFactory: SKBrickLayoutFactory(session: session),
            session: session,
            ballLaunchController: BallLaunchController(),
            paddleMotionController: PaddleMotionController(
                speed: gameTuning.paddleSpeed
            ),
            bounceSpeedPolicy: gameTuning.bounceSpeedPolicy
        )

        let viewModel = GameViewModel(
            session: session,
            gameConfiguration: gameConfiguration,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService,
            brickService: brickService,
            startingLevel: startingLevel
        )

        return (viewModel, gameSceneBuilder)
    }

}
