import Foundation

protocol GameService {
    var state: GameState { get }
    var score: Int { get }
    var remainingLives: Int { get }
    var bricks: [Brick] { get }

    // Game loop entry point
    func launchBall()

    // Events from SpriteKit
    func ballHitBrick(_ brick: Brick)
    func ballHitBottom()
}
