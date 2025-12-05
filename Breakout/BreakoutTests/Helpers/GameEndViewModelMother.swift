@testable import Breakout

@MainActor
struct GameEndViewModelMother {
    static func makeModel() -> GameEndViewModel {
        let navigationState = NavigationState()
        let screenNavigationService = DefaultScreenNavigationService(
            navigationState: navigationState
        )
        let gameResultService = FakeGameResultService()
        return
            GameEndViewModel(
                screenNavigationService: screenNavigationService,
                gameResultService: gameResultService
            )
    }

    static func makeModelAndNavigationState() -> (
        GameEndViewModel, NavigationState
    ) {
        let navigationState = NavigationState()
        let screenNavigationService = DefaultScreenNavigationService(
            navigationState: navigationState
        )
        let gameResultService = FakeGameResultService()
        return (
            GameEndViewModel(
                screenNavigationService: screenNavigationService,
                gameResultService: gameResultService
            ), navigationState
        )
    }

    static func makeModelAndGameResultService() -> (
        GameEndViewModel, FakeGameResultService
    ) {
        let navigationState = NavigationState()
        let screenNavigationService = DefaultScreenNavigationService(
            navigationState: navigationState
        )
        let gameResultService = FakeGameResultService()
        return (
            GameEndViewModel(
                screenNavigationService: screenNavigationService,
                gameResultService: gameResultService
            ), gameResultService
        )
    }
}
