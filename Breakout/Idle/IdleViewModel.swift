import Foundation

@Observable internal final class IdleViewModel {
    private let gameStateService: GameStateService

    internal init(gameStateService: GameStateService) {
        self.gameStateService = gameStateService
    }

    internal func startNewGame() async {
        gameStateService.transition(to: .playing)
    }
}
