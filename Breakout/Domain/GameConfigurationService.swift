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
        try! loader.load()
    }

    func getGameScale() -> CGFloat {
        #if os(macOS)
            return 1.5
        #else
            return UIDevice.current.userInterfaceIdiom == .pad ? 3.0 : 2.0
        #endif
    }

}
