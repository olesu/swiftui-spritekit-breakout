import Foundation
import SpriteKit
import SwiftUI

struct ContentViewWrapper: View {
    @Environment(ConfigurationModel.self)
    private var configurationModel: ConfigurationModel

    var body: some View {
        ContentView(configurationModel: configurationModel)
    }
}

struct ContentView: View {
    @Environment(\.gameScale)
    private var scale

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
                width: viewModel.sceneSize.width * scale,
                height: viewModel.sceneSize.height * scale
            )
        }
    }
}

#Preview {
    ContentView(configurationModel: ConfigurationModel(using: PreviewGameConfigurationService()))
        .environment(\.gameScale, 1.0)
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
}

