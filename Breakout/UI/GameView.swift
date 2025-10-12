import Foundation
import SpriteKit
import SwiftUI

struct GameView: View {
    @Environment(\.gameConfiguration)
    private var gameConfiguration

    @State
    private var gameViewModel = GameViewModel()

    private var sceneSize: CGSize {
        CGSize(
            width: gameConfiguration.sceneWidth,
            height: gameConfiguration.sceneHeight
        )
    }
    
    private var brickArea: CGRect {
        CGRect(x: 20, y: 330, width: 280, height: 120)
    }

    private var frameWidth: CGFloat {
        gameConfiguration.sceneWidth
    }

    private var frameHeight: CGFloat {
        gameConfiguration.sceneHeight
    }

    var body: some View {
        VStack {
            SpriteView(
                scene: GameScene(
                    size: sceneSize,
                    brickArea: brickArea
                )
            )
            .frame(width: frameWidth, height: frameHeight)
        }
    }
}

#Preview {
    GameView()
        .environment(
            \.gameConfiguration,
             GameConfiguration(
                sceneWidth: 320,
                sceneHeight: 480,
             )
        )
}
