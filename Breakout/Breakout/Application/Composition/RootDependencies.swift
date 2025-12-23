struct RootDependencies {
    let navigationCoordinator: NavigationCoordinator
    let applicationConfiguration: ApplicationConfiguration
    let gameConfiguration: GameConfiguration
    let screenNavigationService: DefaultScreenNavigationService
    let gameStateStorage: InMemoryStorage
    let gameResultService: RealGameResultService
    let idleViewModel: IdleViewModel
    let gameViewModel: GameViewModel
    let gameEndViewModel: GameEndViewModel
    let sceneBuilder: GameSceneBuilder
}
