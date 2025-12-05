@testable import Breakout

struct GameViewModelTestContext {
    let viewModel: GameViewModel
    let navigationService: FakeScreenNavigationService
    let gameResultService: FakeGameResultService
    let configurationService: FakeGameConfigurationService
}

@MainActor
struct GameViewModelMother {
    static func makeContext() -> GameViewModelTestContext {
        let configurationService = FakeGameConfigurationService()
        let navigationService = FakeScreenNavigationService()
        let gameResultService = FakeGameResultService()
        let gameSession = GameSession(
            repository: InMemoryGameStateRepository(),
            reducer: GameReducer()
        )

        let viewModel = GameViewModel(
            session: gameSession,
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
