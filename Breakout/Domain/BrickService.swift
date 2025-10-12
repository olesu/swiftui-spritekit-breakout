import Foundation

class GameConfigurationService {
    let loader: GameConfigurationLoader
    
    init(loader: GameConfigurationLoader) {
        self.loader = loader
    }
    
    func getGameConfiguration() -> GameConfiguration {
        try! loader.load()
    }
}
