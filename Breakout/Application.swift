import Foundation
import SwiftUI

@main
struct Application: App {
    private let gameConfigurationLoader: GameConfigurationLoader
    private let gameConfigurationService: GameConfigurationService
    private let configurationModel: ConfigurationModel
    
    init() {
        gameConfigurationLoader = JsonGameConfigurationLoader()
        gameConfigurationService = RealGameConfigurationService(loader: gameConfigurationLoader)
        
        configurationModel = ConfigurationModel(using: gameConfigurationService)
    }

    var body: some Scene {
        WindowGroup {
            GameViewWrapper()
                .environment(configurationModel)
        }

        Settings {
            DevSettingsView()
                .frame(minWidth: 300, minHeight: 300)
        }
    }
}
