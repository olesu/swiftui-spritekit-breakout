struct RootDependencies {
    let navigationCoordinator: NavigationCoordinator
    let applicationConfiguration: ApplicationConfiguration
    let gameConfigurationService: RealGameConfigurationService
    let screenNavigationService: RealScreenNavigationService
    let gameStateStorage: InMemoryStorage
    let gameResultService: RealGameResultService
}
