import Foundation
import SpriteKit
import SwiftUI

struct GameViewWrapper: View {
    @Environment(GameConfigurationModel.self)
    private var configurationModel: GameConfigurationModel

    var body: some View {
        GameView(configurationModel: configurationModel)
    }
}

struct GameView: View {
    @State private var viewModel: GameViewModel

    init(configurationModel: GameConfigurationModel) {
        _viewModel = State(
            initialValue: GameViewModel(configurationModel: configurationModel)
        )
    }

    var body: some View {
        VStack {
            SpriteView(
                scene: GameScene(
                    size: viewModel.sceneSize,
                    brickArea: viewModel.brickArea,
                    nodes: viewModel.createNodes()
                )
            )
        }
    }
}

#Preview {
    let configurationModel = GameConfigurationModel(service: PreviewGameConfigurationService())
    GameViewWrapper()
        .environment(configurationModel)
        .frame(
            width: configurationModel.frameWidth,
            height: configurationModel.frameHeight
        )
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

