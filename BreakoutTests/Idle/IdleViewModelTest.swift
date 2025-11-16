import Testing

@testable import Breakout

struct IdleViewModelTest {

    @Test func canStartANewGame() async throws {
        let fakeGameStateService = FakeGameStateService()
        let viewModel = IdleViewModel(gameStateService: fakeGameStateService)

        await viewModel.startNewGame()

        #expect(fakeGameStateService.stateTransitionedToPlaying == true)
    }

}
