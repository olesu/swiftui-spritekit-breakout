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
            gameEndViewModel: gameResult.gameEndViewModel
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
        viewModel: GameViewModel
    ) {
        let repository = InMemoryGameStateRepository()
        let reducer = GameReducer()

        let session = GameSession(
            repository: repository,
            reducer: reducer
        )

        let bricks = BrickFactory.makeBricks(from: loadBrickLayout(
            configurationService: configurationService,
            loadBrickLayoutService: LoadBrickLayoutService(
                adapter: JsonBrickLayoutAdapter()
            ))
        )
        let nodeCreator = SpriteKitNodeCreator(bricks: bricks)

        let collisionRouter = DefaultCollisionRouter(
            brickIdentifier: NodeNameBrickIdentifier()
        )

        let viewModel = GameViewModel(
            session: session,
            configurationService: configurationService,
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService,
            nodeCreator: nodeCreator,
            collisionRouter: collisionRouter,
            bricks: bricks
        )

        return (reducer, viewModel)
    }

    static private func loadBrickLayout(
        configurationService: GameConfigurationService,
        loadBrickLayoutService: LoadBrickLayoutService
    ) -> [BrickLayoutData] {
        let cfg = configurationService.getGameConfiguration()

        do {
            let domainBricks = try loadBrickLayoutService.load(
                named: cfg.layoutFileName
            )
            return domainBricks
        } catch {
            Logger().error(
                "Failed to load brick layout \(cfg.layoutFileName) Using empty layout as fallback."
            )
            return []
        }
    }

}
