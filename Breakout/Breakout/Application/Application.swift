import Foundation
import SwiftUI

@main
struct Application: App {
    let deps: RootDependencies = CompositionRoot.makeRootDependencies(
        startingLevel: GameWiring.makeStartingLevel(
            policy: AppEnvironment.startingLevelPolicy
        )
    )

    var body: some Scene {
        WindowGroup {
            RootView(deps)
        }
    }
}
