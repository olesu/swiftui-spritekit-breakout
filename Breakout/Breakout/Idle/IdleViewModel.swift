import Foundation

@Observable final class IdleViewModel {
    private let screenNavigationService: ScreenNavigationService

    internal init(screenNavigationService: ScreenNavigationService) {
        self.screenNavigationService = screenNavigationService
    }

    internal func startNewGame() {
        screenNavigationService.navigate(to: .game)
    }
}
