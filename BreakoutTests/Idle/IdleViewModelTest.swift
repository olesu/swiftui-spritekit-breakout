import Testing

@testable import Breakout

struct IdleViewModelTest {

    @Test func canStartANewGame() async throws {
        let navigationState = NavigationState()
        let screenNavigationService = RealScreenNavigationService(navigationState: navigationState)
        let viewModel = IdleViewModel(screenNavigationService: screenNavigationService)

        await viewModel.startNewGame()

        #expect(navigationState.currentScreen == .game)
    }

}
