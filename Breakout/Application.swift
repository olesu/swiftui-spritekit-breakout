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

    let configurationModel = ConfigurationModel(
        using: RealGameConfigurationService(
            loader: JsonGameConfigurationLoader()
        )
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.gameScale, calculatedScale)
                .environment(configurationModel)
        }

        Settings {
            DevSettingsView()
                .frame(minWidth: 300, minHeight: 300)
        }
    }
}
