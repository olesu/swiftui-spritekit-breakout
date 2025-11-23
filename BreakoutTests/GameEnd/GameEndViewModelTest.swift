import Testing

@testable import Breakout

struct GameEndViewModelTest {

    @Test func canPlayAgain() async throws {
        let navigationState = NavigationState()
        let screenNavigationService = RealScreenNavigationService(navigationState: navigationState)
        let viewModel = GameEndViewModel(screenNavigationService: screenNavigationService)

        await viewModel.playAgain()

        #expect(navigationState.currentScreen == .game)
    }

}
