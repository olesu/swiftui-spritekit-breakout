import Foundation
import SwiftUI

@main
struct Application: App {
    let rootDependencies: RootDependencies = CompositionRoot.makeRootDependencies()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(rootDependencies.navigationCoordinator)
                .environment(rootDependencies.screenNavigationService)
                .environment(rootDependencies.gameConfigurationService)
                .environment(rootDependencies.gameStateStorage)
                .environment(rootDependencies.gameResultService)
                .environment(rootDependencies.applicationConfiguration)
        }
    }
}
