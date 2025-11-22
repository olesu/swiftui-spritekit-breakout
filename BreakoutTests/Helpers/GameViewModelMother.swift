@testable import Breakout

struct GameViewModelMother {
    static func makeGameViewModel() -> GameViewModel {
        return GameViewModel(
            configurationService: FakeGameConfigurationService(),
            screenNavigationService: FakeScreenNavigationService()
        )
    }

    static func makeGameViewModelAndScreenNavigationService() -> (
        GameViewModel, FakeScreenNavigationService
    ) {
        let navigationService = FakeScreenNavigationService()
        return (
            GameViewModel(
                configurationService: FakeGameConfigurationService(),
                screenNavigationService: navigationService
            ), navigationService
        )
    }
}
