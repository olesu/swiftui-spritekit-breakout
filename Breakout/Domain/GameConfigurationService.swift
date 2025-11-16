import Foundation

protocol GameConfigurationService {
    func getGameConfiguration() -> GameConfiguration
    func getGameScale() -> CGFloat
}

class RealGameConfigurationService: GameConfigurationService {
    let loader: GameConfigurationLoader

    init(loader: GameConfigurationLoader) {
        self.loader = loader
    }

    func getGameConfiguration() -> GameConfiguration {
        do {
            return try loader.load()
        } catch {
            return createFallbackConfiguration()
        }
    }

    func getGameScale() -> CGFloat {
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
