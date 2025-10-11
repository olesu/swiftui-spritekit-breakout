import Foundation

@Observable
final class GameViewModel {
    var scoreCard = ScoreCard()
    var livesCard = LivesCard(3)
    
    func someFunc() {
        print("some func...")
    }
    
    func score(_ score: Int) {
        scoreCard.score(score)
    }
    
    func score() -> Int {
        return scoreCard.total
    }
}
