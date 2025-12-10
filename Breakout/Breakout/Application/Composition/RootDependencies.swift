struct RootDependencies {
    let navigationCoordinator: NavigationCoordinator
    let applicationConfiguration: ApplicationConfiguration
    let gameConfigurationService: DefaultGameConfigurationService
    let screenNavigationService: DefaultScreenNavigationService
    let gameStateStorage: InMemoryStorage
    let gameResultService: RealGameResultService
    let gameService: GameReducer
    let idleViewModel: IdleViewModel
    let gameViewModel: GameViewModel
    let gameEndViewModel: GameEndViewModel
    let sceneBuilder: GameSceneBuilder
}
