import Foundation

@Observable class IdleModel {
    private let gameStateService: GameStateService
    
    init(gameStateService: GameStateService) {
        self.gameStateService = gameStateService
    }
    
    func startNewGame() async {
        gameStateService.transitionToPlaying()
    }
}
