import Foundation

internal protocol GameEngine {
    var currentScore: Int { get }
    var remainingLives: Int { get }
    var shouldResetBall: Bool { get }

    func start()
    func process(event: GameEvent)
    func acknowledgeBallReset()
}
