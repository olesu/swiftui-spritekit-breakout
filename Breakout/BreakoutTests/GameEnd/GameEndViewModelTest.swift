import Testing

@testable import Breakout

struct GameEndViewModelTest {
    @Test func canPlayAgain() {
        let (viewModel, navigationState) =
            GameEndViewModelMother.makeModelAndNavigationState()

        viewModel.playAgain()

        #expect(navigationState.currentScreen == .game)
    }

    @Test func showsYouWonMessageWhenGameWasWon() {
        let (viewModel, gameResultService) =
            GameEndViewModelMother.makeModelAndGameResultService()

        gameResultService.save(didWin: true, score: 0)

        #expect(viewModel.message == "YOU WON!")
    }

    @Test func showsGameOverMessageWhenLivesRunOut() {
        let (viewModel, gameResultService) =
            GameEndViewModelMother.makeModelAndGameResultService()

        gameResultService.save(didWin: false, score: 0)

        #expect(viewModel.message == "GAME OVER")
    }

    @Test func exposesTheFinalScore() {
        let (viewModel, gameResultService) =
            GameEndViewModelMother.makeModelAndGameResultService()

        gameResultService.save(didWin: true, score: 1234)

        #expect(viewModel.score == 1234)
    }
}
