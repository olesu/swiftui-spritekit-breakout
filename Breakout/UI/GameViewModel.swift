import Foundation

@Observable
final class GameViewModel {
    var scoreCard = ScoreCard()
    var livesCard = LivesCard(3)
    
    func score(_ score: Int) {
        scoreCard.score(score)
    }
    
    func score() -> Int {
        scoreCard.total
    }
    
    func lifeWasLost() {
        livesCard.lifeWasLost()
    }
    
    func lives() -> Int {
        livesCard.remaining
    }
}
