import Foundation
import SpriteKit
import SwiftUI

struct GameView: View {
    @Environment(\.gameScale)
    private var scale
    
    @State
    private var gameViewModel = GameViewModel(
        gameConfigurationService: GameConfigurationService(loader: JsonGameConfigurationLoader())
    )

    var body: some View {
        VStack {
            SpriteView(
                scene: GameScene(
                    size: gameViewModel.sceneSize,
                    brickArea: gameViewModel.brickArea
                )
            )
            .frame(
                width: gameViewModel.sceneSize.width * scale,
                height: gameViewModel.sceneSize.height * scale
            )
        }
    }
}

#Preview {
    GameView()
        .environment(\.gameScale, 1.0)
}

