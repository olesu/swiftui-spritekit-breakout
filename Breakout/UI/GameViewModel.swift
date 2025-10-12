import Foundation

@Observable
final class GameViewModel {
    let gameConfigurationService: GameConfigurationService

    var scoreCard = ScoreCard()
    var livesCard = LivesCard(3)

    var brickArea: CGRect {
        let r = gameConfigurationService.getGameConfiguration()
        return CGRect(
            x: r.brickArea.x,
            y: r.brickArea.y,
            width: r.brickArea.width,
            height: r.brickArea.height
        )
    }
    
    var sceneSize: CGSize {
        let r = gameConfigurationService.getGameConfiguration()
        return CGSize(width: r.sceneWidth, height: r.sceneHeight)
    }
    
    init(gameConfigurationService: GameConfigurationService) {
        self.gameConfigurationService = gameConfigurationService
    }

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
