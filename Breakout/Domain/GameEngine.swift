import Foundation

protocol GameEngine {
    var currentScore: Int { get }
    var remainingLives: Int { get }
    var remainingBrickCount: Int { get }
    var currentStatus: GameState { get }

    func start()
    func process(event: GameEvent)
}
