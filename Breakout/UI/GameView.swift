import Foundation
import SpriteKit
import SwiftUI

struct GameView: View {
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
            .frame(width: 320, height: 480)
        }
    }
}

#Preview {
    GameView()
}
