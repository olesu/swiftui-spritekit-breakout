import Foundation
import SwiftUI

@main
struct Application: App {
    let bootState: ApplicationBootState = {
        do {
            let loader = GameWiring.makeGameConfigurationLoader()

            let context = try ApplicationComposer.compose(
                startingLevel: GameWiring.makeStartingLevel(
                    policy: AppConfiguration.startingLevelPolicy()
                ),
                gameConfigurationLoader: loader
            )
            return ApplicationBootState.running(context)
        } catch {
            return .failed(.configuration(error))
        }
    }()

    var body: some Scene {
        WindowGroup {
            switch bootState {
            case .running(let context):
                RootView(context)
            case .failed(let error):
                ErrorView(error: error)
            }
        }
    }
}
