import Foundation

protocol GameConfigurationService {
    func getGameConfiguration() -> GameConfiguration
}

class RealGameConfigurationService: GameConfigurationService {
    let loader: GameConfigurationLoader
    
    init(loader: GameConfigurationLoader) {
        self.loader = loader
    }
    
    func getGameConfiguration() -> GameConfiguration {
        try! loader.load()
    }
}
