import Foundation
import SwiftUI

@Observable class InMemoryStorage {
    var state = GameState.idle
}

@main
struct Application: App {
    private let navigationCoordinator: NavigationCoordinator
    private let gameModel: GameConfigurationModel
    private let idleViewModel: IdleViewModel

    init() {
        let storage = InMemoryStorage()
        let adapter = InMemoryGameStateAdapter(storage: storage)
        let gameStateService = RealGameStateService(adapter: adapter)

        navigationCoordinator = NavigationCoordinator(storage: storage)

        gameModel = GameConfigurationModel(
            service: RealGameConfigurationService(
                loader: JsonGameConfigurationLoader()
            )
        )

        idleViewModel = IdleViewModel(gameStateService: gameStateService)
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch navigationCoordinator.currentScreen {
                case .idle:
                    IdleViewWrapper()
                        .environment(idleViewModel)
                case .game:
                    GameViewWrapper()
                        .environment(gameModel)
                }
            }
            .frame(
                width: gameModel.frameWidth,
                height: gameModel.frameHeight
            )
        }

        Settings {
            DevSettingsView()
                .frame(minWidth: 300, minHeight: 300)
        }
    }
}
