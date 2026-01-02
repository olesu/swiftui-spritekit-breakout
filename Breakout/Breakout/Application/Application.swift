import Foundation
import SwiftUI

@main
struct Application: App {
    @State private var bootState: ApplicationBootState = .loading

    var body: some Scene {
        WindowGroup {
            Group {
                switch bootState {
                case .loading:
                    Text("Loading...")
                case .running(let context):
                    RootView(context)
                case .failed(let error):
                    ErrorView(error: error)
                }
            }.task {
                await bootstrap()
            }
        }
    }
    
    private func bootstrap() async {
        do {
            /*
             let core = try await Task.detached {
                try GameCoreLoader.load()
             }.value
             */
            
            let context = try loadContext()
            bootState = .running(context)
        } catch {
            bootState = .failed(.configuration(error))
        }
    }

    private func loadContext() throws -> AppContext {
        try ApplicationComposer.compose(
            startingLevel: GameWiring.makeStartingLevel(
                policy: AppConfiguration.startingLevelPolicy()
            ),
            gameConfigurationLoader:
                GameWiring.makeGameConfigurationLoader()
        )
    }

}
