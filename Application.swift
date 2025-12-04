import Foundation
import SwiftUI

@main
struct Application: App {
    let deps: RootDependencies = CompositionRoot.makeRootDependencies()
    
    var body: some Scene {
        WindowGroup {
            RootView(deps)
        }
    }
}
