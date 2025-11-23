import Testing

@testable import Breakout

struct GameEndViewModelTest {

    @Test func canPlayAgain() async throws {
        let navigationState = NavigationState()
        let screenNavigationService = RealScreenNavigationService(navigationState: navigationState)
        let gameResultService = FakeGameResultService(won: true)
        let viewModel = GameEndViewModel(
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService
        )

        await viewModel.playAgain()

        #expect(navigationState.currentScreen == .game)
    }

    @Test func showsYouWonMessageWhenGameWasWon() async throws {
        let navigationState = NavigationState()
        let screenNavigationService = RealScreenNavigationService(navigationState: navigationState)
        let gameResultService = FakeGameResultService(won: true)
        let viewModel = GameEndViewModel(
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService
        )

        #expect(viewModel.message == "YOU WON!")
    }
}

struct FakeGameResultService: GameResultService {
    let won: Bool

    func didWin() -> Bool {
        won
    }

}
