import Foundation
import SwiftUI

@main
struct Application: App {
    private let gameConfigurationModel: GameConfigurationModel
    
    init() {
        let gameConfigurationLoader = JsonGameConfigurationLoader()
        let gameConfigurationService = RealGameConfigurationService(loader: gameConfigurationLoader)
        
        gameConfigurationModel = GameConfigurationModel(service: gameConfigurationService)
    }

    var body: some Scene {
        WindowGroup {
            GameViewWrapper()
                .environment(gameConfigurationModel)
        }

        Settings {
            DevSettingsView()
                .frame(minWidth: 300, minHeight: 300)
        }
    }
}
