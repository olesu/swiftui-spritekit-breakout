import Foundation
import SwiftUI

@main
struct Application: App {
    let calculatedScale: CGFloat = {
        #if os(macOS)
            return 2.0
        #else
            return UIDevice.current.userInterfaceIdiom == .pad ? 3.0 : 2.0
        #endif
    }()
    
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
            ContentViewWrapper()
                .environment(\.gameScale, calculatedScale)
                .environment(configurationModel)
        }

        Settings {
            DevSettingsView()
                .frame(minWidth: 300, minHeight: 300)
        }
    }
}
