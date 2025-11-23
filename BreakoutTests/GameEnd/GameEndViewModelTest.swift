import Testing

@testable import Breakout

struct GameEndViewModelTest {
    @Test func canPlayAgain() async throws {
        let (viewModel, navigationState) =
            GameEndViewModelMother.makeModelAndNavigationState(
                won: true,
                score: 0
            )

        await viewModel.playAgain()

        #expect(navigationState.currentScreen == .game)
    }

    @Test func showsYouWonMessageWhenGameWasWon() async throws {
        let viewModel = GameEndViewModelMother.makeModel(won: true, score: 0)

        #expect(viewModel.message == "YOU WON!")
    }

    @Test func showsGameOverMessageWhenLivesRunOut() async throws {
        let viewModel = GameEndViewModelMother.makeModel(won: false, score: 0)

        #expect(viewModel.message == "GAME OVER")
    }

    @Test func exposesTheFinalScore() async throws {
        let viewModel = GameEndViewModelMother.makeModel(won: true, score: 1234)

        #expect(viewModel.score == 1234)
    }
}

struct FakeGameResultService: GameResultService {
    private let _won: Bool
    private let _score: Int

    init(won: Bool, score: Int) {
        self._won = won
        self._score = score
    }

    var didWin: Bool {
        _won
    }

    var score: Int {
        _score
    }

}
