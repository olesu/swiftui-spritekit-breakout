import Foundation
import SwiftUI

@Observable class InMemoryStorage {
    var state = GameState.idle
}

@main
struct Application: App {
    private let gameModel: GameConfigurationModel
    private let idleViewModel: IdleViewModel

    private var storage: InMemoryStorage

    init() {
        storage = InMemoryStorage()

        gameModel = GameConfigurationModel(
            service: RealGameConfigurationService(
                loader: JsonGameConfigurationLoader()
            )
        )

        idleViewModel = IdleViewModel(
            gameStateService: RealGameStateService(
                adapter: InMemoryGameStateAdapter(storage: storage)
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch storage.state {
                case .idle:
                    IdleViewWrapper()
                        .environment(idleViewModel)
                case .playing:
                    GameViewWrapper()
                        .environment(gameModel)
                case .won, .gameOver:
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
