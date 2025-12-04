import Testing

@testable import Breakout

struct GameEndViewModelTest {
    @Test func canPlayAgain() async throws {
        let (viewModel, navigationState) =
            GameEndViewModelMother.makeModelAndNavigationState()

        await viewModel.playAgain()

        #expect(navigationState.currentScreen == .game)
    }

    @Test func showsYouWonMessageWhenGameWasWon() async throws {
        let (viewModel, gameResultService) =
            GameEndViewModelMother.makeModelAndGameResultService()

        gameResultService.save(didWin: true, score: 0)

        #expect(viewModel.message == "YOU WON!")
    }

    @Test func showsGameOverMessageWhenLivesRunOut() async throws {
        let (viewModel, gameResultService) =
            GameEndViewModelMother.makeModelAndGameResultService()

        gameResultService.save(didWin: false, score: 0)

        #expect(viewModel.message == "GAME OVER")
    }

    @Test func exposesTheFinalScore() async throws {
        let (viewModel, gameResultService) =
            GameEndViewModelMother.makeModelAndGameResultService()

        gameResultService.save(didWin: true, score: 1234)

        #expect(viewModel.score == 1234)
    }
}
