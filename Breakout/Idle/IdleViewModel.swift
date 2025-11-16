import Foundation

@Observable class IdleViewModel {
    private let gameStateService: GameStateService

    init(gameStateService: GameStateService) {
        self.gameStateService = gameStateService
    }

    func startNewGame() async {
        gameStateService.transitionToPlaying()
    }
}
