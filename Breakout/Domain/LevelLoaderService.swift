import Foundation

class LevelLoaderService {
    func loadLevel() -> Level {
        Level(
            levelName: "my level",
            mapCols: 1,
            mapRows: 1,
            brickTypes: [
                BrickType(
                    id: "1",
                    colorName: "Blue",
                    scoreValue: 1,
                    hitsToBreak: 1
                )
            ],
            layout: [
                [1]
            ]
        )
    }
}

