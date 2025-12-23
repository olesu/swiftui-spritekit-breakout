import Foundation

struct ApplicationConfiguration {
    private let gameConfiguration: GameConfiguration
    private let gameScalePolicy: GameScalePolicy

    init(
        gameConfiguration: GameConfiguration,
        gameScalePolicy: GameScalePolicy
    ) {
        self.gameConfiguration = gameConfiguration
        self.gameScalePolicy = gameScalePolicy
    }

    var windowWidth: CGFloat {
        return gameConfiguration.sceneWidth * gameScalePolicy.scale
    }

    var windowHeight: CGFloat {
        return gameConfiguration.sceneHeight * gameScalePolicy.scale
    }
}
