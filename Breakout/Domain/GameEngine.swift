import Foundation

protocol GameEngine {
    var currentScore: Int { get }
    var remainingLives: Int { get }

    func start()
    func process(event: GameEvent)
}
