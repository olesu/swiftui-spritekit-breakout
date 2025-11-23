import Foundation

@Observable internal final class GameEndViewModel {
    private let screenNavigationService: ScreenNavigationService

    internal init(screenNavigationService: ScreenNavigationService) {
        self.screenNavigationService = screenNavigationService
    }

    internal func playAgain() async {
        screenNavigationService.navigate(to: .game)
    }
}
