import Foundation

@Observable class GameViewModel {
    var scoreCard = ScoreCard()
    var livesCard = LivesCard(3)

    func loadLevel() {
        let _ = LevelLoaderService().loadLevel()
        print("load default level")
    }

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
