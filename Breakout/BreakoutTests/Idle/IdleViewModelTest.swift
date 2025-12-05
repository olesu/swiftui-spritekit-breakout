import Testing

@testable import Breakout

@MainActor
struct IdleViewModelTest {

    @Test func canStartANewGame() {
        let navigationState = NavigationState()
        let screenNavigationService = DefaultScreenNavigationService(navigationState: navigationState)
        let viewModel = IdleViewModel(screenNavigationService: screenNavigationService)

        viewModel.startNewGame()

        #expect(navigationState.currentScreen == .game)
    }

}
