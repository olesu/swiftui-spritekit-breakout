import Foundation
import OSLog

final class DefaultGameConfigurationService {
    private let logger = Logger(subsystem: "Breakout", category: "Configuration")
    private let gameConfigurationAdapter: GameConfigurationAdapter

    internal init(gameConfigurationAdapter: GameConfigurationAdapter) {
        self.gameConfigurationAdapter = gameConfigurationAdapter
    }

    internal func getGameConfiguration() -> GameConfiguration {
        do {
            return try gameConfigurationAdapter.load()
        } catch {
            logger.error("Failed to load game configuration: \(error.localizedDescription)")
            return GameConfiguration.defaultValue()
        }
    }

}
