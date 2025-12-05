import Foundation
import os.log

/// Service for retrieving game configuration settings.
///
/// Provides platform-specific configuration values such as scene dimensions
/// and scaling factors. Falls back to safe defaults if configuration cannot be loaded.
internal protocol GameConfigurationService {
    /// Retrieves the game configuration containing scene dimensions and layout.
    /// - Returns: The game configuration, or a fallback configuration if loading fails.
    func getGameConfiguration() -> GameConfiguration

    /// Retrieves the platform-specific scaling factor for the game scene.
    /// - Returns: The scale factor (1.5 for macOS, 2.0-3.0 for iOS depending on device).
    func getGameScale() -> CGFloat
}

@Observable
internal final class RealGameConfigurationService: GameConfigurationService {
    private let loader: GameConfigurationAdapter

    internal init(loader: GameConfigurationAdapter) {
        self.loader = loader
    }

    internal func getGameConfiguration() -> GameConfiguration {
        do {
            return try loader.load()
        } catch {
            os_log(.error, "Failed to load game configuration: %{public}@. Using fallback configuration.", error.localizedDescription)
            return createFallbackConfiguration()
        }
    }

    internal func getGameScale() -> CGFloat {
        #if os(macOS)
            return 1.5
        #else
            return UIDevice.current.userInterfaceIdiom == .pad ? 3.0 : 2.0
        #endif
    }

    private func createFallbackConfiguration() -> GameConfiguration {
        GameConfiguration(
            sceneWidth: 320,
            sceneHeight: 480,
            brickArea: BrickArea(
                x: 20,
                y: 330,
                width: 280,
                height: 120
            )
        )
    }

}
