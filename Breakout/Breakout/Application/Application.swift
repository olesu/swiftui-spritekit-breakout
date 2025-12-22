import Foundation
import SwiftUI

@main
struct Application: App {
    let deps: RootDependencies = CompositionRoot.makeRootDependencies(
        startingLevel: GameWiring.makeStartingLevel(policy: .production)
    )

    var body: some Scene {
        WindowGroup {
            RootView(deps)
        }
    }
}
