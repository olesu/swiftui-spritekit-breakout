import Testing
import SpriteKit
@testable import Breakout

struct BottomWallCollisionTests {
    @Test func ballHittingBottomWallReducesLife() {
        let gameService = AGameService(remainingLives: 2)
        let scene = GameScene(gameService: gameService, size: CGSize(width: 400, height: 600))
        
        // Launch the ball
        gameService.launchBall()
        
        // Simulate ball hitting bottom wall
        scene.ballHitBottom()
        
        #expect(gameService.remainingLives == 1)
    }
}