import Foundation
import os.log

internal protocol GameConfigurationService {
    func getGameConfiguration() -> GameConfiguration
    func getGameScale() -> CGFloat
}

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
