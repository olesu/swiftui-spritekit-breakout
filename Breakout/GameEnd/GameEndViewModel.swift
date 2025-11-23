import Foundation

@Observable internal final class GameEndViewModel {
    private let screenNavigationService: ScreenNavigationService
    private let gameResultService: GameResultService

    internal var message: String {
        "YOU WON!"
    }

    internal init(screenNavigationService: ScreenNavigationService, gameResultService: GameResultService) {
        self.screenNavigationService = screenNavigationService
        self.gameResultService = gameResultService
    }

    internal func playAgain() async {
        screenNavigationService.navigate(to: .game)
    }
}
