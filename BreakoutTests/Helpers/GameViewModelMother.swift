@testable import Breakout

struct GameViewModelTestContext {
    let viewModel: GameViewModel
    let navigationService: FakeScreenNavigationService
    let gameResultService: FakeGameResultService
    let configurationService: FakeGameConfigurationService
}

struct GameViewModelMother {
    static func makeContext() -> GameViewModelTestContext {
        let configurationService = FakeGameConfigurationService()
        let navigationService = FakeScreenNavigationService()
        let gameResultService = FakeGameResultService()

        let viewModel = GameViewModel(
            service: BreakoutGameService(),
            repository: InMemoryGameStateRepository(),
            configurationService: configurationService,
            screenNavigationService: navigationService,
            gameResultService: gameResultService
        )

        return GameViewModelTestContext(
            viewModel: viewModel,
            navigationService: navigationService,
            gameResultService: gameResultService,
            configurationService: configurationService
        )
    }
}
