import Foundation
import SwiftUI

enum GameState {
    case idle
    case playing
}

struct GameManager {
    let state = GameState.idle
}

@main
struct Application: App {
    private let gameConfigurationModel: GameConfigurationModel
    private let gameManager = GameManager()
    private let idleModel: IdleModel
    
    init() {
        let gameConfigurationLoader = JsonGameConfigurationLoader()
        let gameConfigurationService = RealGameConfigurationService(loader: gameConfigurationLoader)
        
        gameConfigurationModel = GameConfigurationModel(service: gameConfigurationService)
        
        idleModel = IdleModel(
            gameStateService: RealGameStateService()
        )
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch gameManager.state {
                case .idle:
                    IdleViewWrapper()
                        .environment(idleModel)
                case .playing:
                    GameViewWrapper()
                        .environment(gameConfigurationModel)
                }
            }
            .frame(
                width: gameConfigurationModel.frameWidth,
                height: gameConfigurationModel.frameHeight
            )
        }

        Settings {
            DevSettingsView()
                .frame(minWidth: 300, minHeight: 300)
        }
    }
}
