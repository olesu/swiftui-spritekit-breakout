import Foundation

@Observable internal final class IdleViewModel {
    private let screenNavigationService: ScreenNavigationService

    internal init(screenNavigationService: ScreenNavigationService) {
        self.screenNavigationService = screenNavigationService
    }

    internal func startNewGame() async {
        screenNavigationService.navigate(to: .game)
    }
}
