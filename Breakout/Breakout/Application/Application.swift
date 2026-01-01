import Foundation
import SwiftUI

@main
struct Application: App {
    let bootState = resolveBootState()

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

    private static func resolveBootState() -> ApplicationBootState {
        do {
            return ApplicationBootState.running(try loadContext())
        } catch {
            return .failed(.configuration(error))
        }
    }

    private static func loadContext() throws -> AppContext {
        try ApplicationComposer.compose(
            startingLevel: GameWiring.makeStartingLevel(
                policy: AppConfiguration.startingLevelPolicy()
            ),
            gameConfigurationLoader:
                GameWiring.makeGameConfigurationLoader()
        )
    }

}
