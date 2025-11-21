@testable import Breakout
import Testing

struct LivesCardTest {

    @Test func startsWithSpecifiedNumberOfLives() async throws {
        let livesCard = LivesCard(3)
        #expect(livesCard.remaining == 3)
    }
    
    @Test func losesALifeWhenHit() async throws {
        var livesCard = LivesCard(3)
        
        livesCard.lifeWasLost()
        
        #expect(livesCard.remaining == 2)
    }
    
    @Test func cannotGoBelowZeroLives() async throws {
        var livesCard = LivesCard(3)
        
        (0..<3).forEach { _ in
            livesCard.lifeWasLost()
        }
        
        #expect(livesCard.gameOver)
    }

}
