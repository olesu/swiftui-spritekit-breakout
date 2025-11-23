@testable import Breakout

struct GameEndViewModelMother {
    static func makeModel(won: Bool, score: Int) -> GameEndViewModel {
        let navigationState = NavigationState()
        let screenNavigationService = RealScreenNavigationService(
            navigationState: navigationState
        )
        let gameResultService = FakeGameResultService(won: won, score: score)
        return
            GameEndViewModel(
                screenNavigationService: screenNavigationService,
                gameResultService: gameResultService
            )
    }

    static func makeModelAndNavigationState(won: Bool, score: Int) -> (
        GameEndViewModel, NavigationState
    ) {
        let navigationState = NavigationState()
        let screenNavigationService = RealScreenNavigationService(
            navigationState: navigationState
        )
        let gameResultService = FakeGameResultService(won: won, score: score)
        return (
            GameEndViewModel(
                screenNavigationService: screenNavigationService,
                gameResultService: gameResultService
            ), navigationState
        )
    }
}
