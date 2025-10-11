import Foundation
import SpriteKit
import SwiftUI

struct GameView: View {
    @Binding var autoPaddleConfig: AutoPaddleConfig
    
    @Environment(\.gameConfiguration) private var gameConfiguration

    @Binding var livesCard: LivesCard
    @State private var gameViewModel = GameViewModel()

    @State private var scene: BreakoutScene?
    @State private var bricks: Bricks?

    var body: some View {
        Group {
            if let scene = scene {
                SpriteView(scene: scene)
                    .frame(width: 320, height: 480)
                    .onAppear {
                        scene.scaleMode = .aspectFit
                        scene.backgroundColor = .black

                        scene.onBrickRemoved = {
                            DispatchQueue.main.async {
                                gameViewModel.score(1)
                                scene.updateScoreLabel(to: gameViewModel.score())
                            }
                        }

                        gameViewModel.someFunc()
                        scene.updateScoreLabel(to: gameViewModel.score())
                        scene.updateLivesLabel(to: livesCard.remaining)

                        scene.onBallMissed = {
                            DispatchQueue.main.async {
                                gameViewModel.someFunc()
                                livesCard.lifeWasLost()
                                scene.updateLivesLabel(to: livesCard.remaining)
                            }
                        }
                    }
                    .onChange(of: autoPaddleConfig) { _, newValue in
                        scene.apply(autoPaddleConfig: newValue)
                    }
                    .onChange(of: autoPaddleConfig) { _, newValue in
                        autoPaddleConfig = newValue
                        scene.apply(autoPaddleConfig: newValue)
                    }
            } else {
                Color.clear
                    .frame(width: 320, height: 480)
                    .onAppear {
                        var collectedBricks = Bricks()
                        let newScene = BreakoutScene(
                            gameSize: CGSize(
                                width: gameConfiguration.sceneWidth,
                                height: gameConfiguration.sceneHeight
                            ),
                            autoPaddleConfig: autoPaddleConfig,
                            onBrickAdded: { brickName in
                                collectedBricks.add(
                                    Brick(id: BrickId(of: brickName))
                                )
                            }
                        )
                        scene = newScene
                        bricks = collectedBricks
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var autoPaddleConfig = AutoPaddleConfig()
    @Previewable @State var livesCard = LivesCard(3)
    
    GameView(
        autoPaddleConfig: $autoPaddleConfig,
        livesCard: $livesCard
    )
}
