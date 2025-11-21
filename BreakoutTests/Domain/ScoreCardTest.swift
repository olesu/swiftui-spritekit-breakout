@testable import Breakout
import Testing

struct ScoreCardTest {

    @Test func totalIsInitiallyZero() async throws {
        let scoreCard = ScoreCard()
        #expect(scoreCard.total == 0)
    }

    @Test func totalIsOneWhenOnlyScoreIsAOne() async throws {
        var scoreCard = ScoreCard()
        
        scoreCard.score(1)
        
        #expect(scoreCard.total == 1)
    }

    @Test func handlesMultipleScores() async throws {
        var scoreCard = ScoreCard()
        
        scoreCard.score(1)
        scoreCard.score(2)

        #expect(scoreCard.total == 3)
    }

}
