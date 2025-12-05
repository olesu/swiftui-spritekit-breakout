import Foundation
import OSLog

@Observable
final class DefaultGameConfigurationService: GameConfigurationService {
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

    internal func getGameScale() -> CGFloat {
        #if os(macOS)
            return 1.5
        #else
            return UIDevice.current.userInterfaceIdiom == .pad ? 3.0 : 2.0
        #endif
    }

}
