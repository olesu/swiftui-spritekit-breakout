import Foundation

/// Provides application-level configuration.
///
/// Calculates window dimensions based on game configuration and scale.
internal struct ApplicationConfiguration {
    private let gameConfigurationService: GameConfigurationService

    internal init(gameConfigurationService: GameConfigurationService) {
        self.gameConfigurationService = gameConfigurationService
    }

    internal var windowWidth: CGFloat {
        let config = gameConfigurationService.getGameConfiguration()
        let scale = gameConfigurationService.getGameScale()
        return config.sceneWidth * scale
    }

    internal var windowHeight: CGFloat {
        let config = gameConfigurationService.getGameConfiguration()
        let scale = gameConfigurationService.getGameScale()
        return config.sceneHeight * scale
    }
}
