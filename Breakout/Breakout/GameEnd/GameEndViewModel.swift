import Foundation

@Observable internal final class GameEndViewModel {
    private let screenNavigationService: ScreenNavigationService
    private let gameResultService: GameResultService

    internal var message: String {
        gameResultService.didWin ? "YOU WON!" : "GAME OVER"
    }

    internal var score: Int {
        gameResultService.score
    }

    internal init(screenNavigationService: ScreenNavigationService, gameResultService: GameResultService) {
        self.screenNavigationService = screenNavigationService
        self.gameResultService = gameResultService
    }

    internal func playAgain() async {
        screenNavigationService.navigate(to: .game)
    }
}
