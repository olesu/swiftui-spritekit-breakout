import Foundation
import SpriteKit
import SwiftUI

struct GameViewWrapper: View {
    @Environment(ConfigurationModel.self)
    private var configurationModel: ConfigurationModel

    var body: some View {
        GameView(configurationModel: configurationModel)
    }
}

struct GameView: View {
    @State private var viewModel: ViewModel

    init(configurationModel: ConfigurationModel) {
        _viewModel = State(
            initialValue: ViewModel(configurationModel: configurationModel)
        )
    }

    var body: some View {
        VStack {
            SpriteView(
                scene: GameScene(
                    size: viewModel.sceneSize,
                    brickArea: viewModel.brickArea
                )
            )
            .frame(
                width: viewModel.frameWidth,
                height: viewModel.frameHeight
            )
        }
    }
}

#Preview {
    let configurationModel = ConfigurationModel(using: PreviewGameConfigurationService())
    GameViewWrapper()
        .environment(configurationModel)
}

class PreviewGameConfigurationService: GameConfigurationService {
    func getGameConfiguration() -> GameConfiguration {
        GameConfiguration(
            sceneWidth: 320,
            sceneHeight: 480,
            brickArea: BrickArea(
                x: 20,
                y: 330,
                width: 280,
                height: 120
            )
        )
    }

    func getGameScale() -> CGFloat {
        0.5
    }
    
}

